#!/usr/bin/env python3
"""Preview or replace existing variable assignments in local .env files."""

import argparse
import json
import os
import re
import stat
import sys
import tempfile
from contextlib import ExitStack, contextmanager
from dataclasses import dataclass
from pathlib import Path

DEFAULT_IGNORES = {".git", ".venv", "venv", "node_modules", "__pycache__"}
NAME = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
ASSIGNMENT = re.compile(
    r"[ \t]*(?:export[ \t]+)?(?P<name>[A-Za-z_][A-Za-z0-9_]*)[ \t]*="
)
QUOTED_VALUE = re.compile(r"""(?:"(?:[^"\\]|\\[\s\S])*"|'(?:[^'\\]|\\[\s\S])*')""")
AFTER_QUOTE = re.compile(r"[ \t]*(?:#.*)?")
LINE_BREAK = re.compile(r"[\r\n]")
BARE_VALUE = re.compile(r"[A-Za-z0-9_./:@%+,=\-]+")


@dataclass
class Assignment:
    name: str
    start: int
    end: int
    before_comment: str = ""


@dataclass
class EnvFile:
    path: Path
    source: str
    mode: int
    assignments: list[Assignment]


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("variable", nargs="?", help="name of one existing variable")
    source.add_argument(
        "--values-file",
        type=Path,
        help="JSON object mapping names to new string values",
    )
    parser.add_argument(
        "--apply", action="store_true", help="write changes (default: preview)"
    )
    parser.add_argument(
        "--stdin",
        action="store_true",
        help="read one value from stdin in single-variable mode",
    )
    parser.add_argument(
        "--confirm",
        action="store_true",
        help="show each current value on the terminal and ask before replacing",
    )
    parser.add_argument(
        "--max-depth",
        type=int,
        default=4,
        help="directory depth relative to the current directory (default: 3)",
    )
    parser.add_argument(
        "--ignore",
        action="append",
        default=[],
        metavar="NAME",
        help="skip this directory name at any depth",
    )
    args = parser.parse_args()

    if args.variable is not None and not NAME.fullmatch(args.variable):
        parser.error("invalid variable name")
    if args.stdin and (not args.apply or args.values_file is not None):
        parser.error("--stdin requires --apply and one variable name")
    if args.confirm and not args.apply:
        parser.error("--confirm requires --apply")
    if args.max_depth < 0:
        parser.error("--max-depth must be non-negative")
    if any(name in ("", ".", "..") or "/" in name for name in args.ignore):
        parser.error("--ignore expects a directory name")
    return args


def validate_value(value):
    if not isinstance(value, str) or "\0" in value:
        raise ValueError("values must be strings without NUL characters")
    try:
        value.encode("utf-8")
    except UnicodeError:
        raise ValueError("values must be valid UTF-8") from None


def unique_object(pairs):
    result = {}
    for name, value in pairs:
        if name in result:
            raise ValueError("duplicate key in JSON object")
        result[name] = value
    return result


def load_values(path):
    try:
        with path.open(encoding="utf-8") as file:
            values = json.load(file, object_pairs_hook=unique_object)
    except (UnicodeError, json.JSONDecodeError, RecursionError):
        raise ValueError("expected a valid UTF-8 JSON object") from None
    if not isinstance(values, dict) or not values:
        raise ValueError("expected a non-empty JSON object")
    for name, value in values.items():
        if not NAME.fullmatch(name):
            raise ValueError("invalid variable name in JSON object")
        validate_value(value)
    return values


def encode_value(value):
    if BARE_VALUE.fullmatch(value):
        return value
    if ("$" in value or "`" in value) and "'" not in value and "\\" not in value:
        return "'" + value + "'"
    escaped = re.sub(r'(["\\$`])', r"\\\1", value)
    return '"' + escaped + '"'


def value_span(source, start, line_end):
    body = source[start:line_end].lstrip(" \t")
    space = line_end - start - len(body)
    if body.startswith("#") and space:
        return start, start, ""
    start += space
    if body.startswith(('"', "'")):
        quoted = QUOTED_VALUE.match(source, start)
        if quoted is None:
            raise ValueError("unterminated quoted value")
        closing_break = LINE_BREAK.search(source, quoted.end())
        closing_line_end = closing_break.start() if closing_break else len(source)
        suffix = source[quoted.end() : closing_line_end]
        if not AFTER_QUOTE.fullmatch(suffix):
            raise ValueError("unsupported text after quoted value")
        separator = " " if suffix.startswith("#") else ""
        return start, quoted.end(), separator

    comment = re.search(r"[ \t]+#", body)
    value = body[: comment.start()] if comment else body.rstrip(" \t")
    if (len(value) - len(value.rstrip("\\"))) % 2:
        raise ValueError("multiline or unterminated line continuation")
    return start, start + len(value), ""


def read_env(path, names):
    with path.open("rb") as file:
        mode = stat.S_IMODE(os.fstat(file.fileno()).st_mode)
        source = file.read().decode("utf-8")
    assignments = []
    previous_value_end = 0
    for line_number, line in enumerate(
        re.finditer(r"[^\r\n]*(?:\r\n|\n|\r|$)", source), 1
    ):
        if line.start() < previous_value_end:
            continue
        content = line[0].rstrip("\r\n")
        first_column = int(line_number == 1 and content.startswith("\ufeff"))
        match = ASSIGNMENT.match(content, first_column)
        if match:
            try:
                start, end, separator = value_span(
                    source, line.start() + match.end(), line.start() + len(content)
                )
            except ValueError as exc:
                raise ValueError(f"line {line_number}: {exc}") from None
            previous_value_end = end
            if match["name"] in names:
                assignments.append(Assignment(match["name"], start, end, separator))
    return EnvFile(path, source, mode, assignments)


def scan(max_depth, ignores, names) -> tuple[list[EnvFile], bool]:
    files = []
    failed = False

    def walk_error(exc):
        nonlocal failed
        failed = True
        print(f"{exc.filename}: {exc.strerror}", file=sys.stderr)

    for directory, subdirs, filenames in os.walk(".", onerror=walk_error):
        folder = Path(directory)
        subdirs[:] = (
            sorted(set(subdirs) - ignores) if len(folder.parts) < max_depth else []
        )
        if ".env" not in filenames:
            continue
        path = folder / ".env"
        try:
            if not stat.S_ISREG(path.lstat().st_mode):
                continue
            env_file = read_env(path, names)
        except OSError as exc:
            walk_error(exc)
            continue
        except UnicodeError:
            print(f"{path}: file is not valid UTF-8", file=sys.stderr)
            failed = True
            continue
        except ValueError as exc:
            print(f"{path}: {exc}", file=sys.stderr)
            failed = True
            continue
        if env_file.assignments:
            files.append(env_file)
    return files, failed


def replacement(env_file, values, terminal=None):
    pieces = []
    offset = 0
    for assignment in env_file.assignments:
        current = env_file.source[assignment.start : assignment.end]
        new = values[assignment.name]
        if current == new:
            continue
        if terminal is not None:
            terminal_in, terminal_out = terminal
            print(
                f"{ascii(str(env_file.path))} · {assignment.name} = {ascii(current)}",
                file=terminal_out,
            )
            print(
                "Replace this assignment? [y/N] ", end="", file=terminal_out, flush=True
            )
            answer = terminal_in.readline()
            if not answer:
                raise EOFError
            if answer.strip().lower() not in {"y", "yes"}:
                continue
        pieces.append(env_file.source[offset : assignment.start])
        pieces.append(new + assignment.before_comment)
        offset = assignment.end
    pieces.append(env_file.source[offset:])
    return "".join(pieces)


@contextmanager
def interactive_terminal():
    # Keep interactive prompts and current values off redirected streams.
    with ExitStack() as stack:
        terminal_in = stack.enter_context(open("/dev/tty", encoding="utf-8"))
        try:
            fd = os.open("/dev/tty", os.O_WRONLY)
        except OSError:
            if not sys.stderr.isatty():
                raise
            terminal_out = sys.stderr
        else:
            terminal_out = stack.enter_context(os.fdopen(fd, "w", encoding="utf-8"))
        yield terminal_in, terminal_out


def atomic_replace(env_file, updated):
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(
            dir=env_file.path.parent, prefix=".env.rotate-", delete=False
        ) as file:
            temporary = Path(file.name)
            file.write(updated.encode("utf-8"))
            file.flush()
            os.fchmod(file.fileno(), env_file.mode)
        current_mode = env_file.path.lstat().st_mode
        if (
            not stat.S_ISREG(current_mode)
            or stat.S_IMODE(current_mode) != env_file.mode
            or env_file.path.read_bytes() != env_file.source.encode("utf-8")
        ):
            raise ValueError("file changed since scanning")
        os.replace(temporary, env_file.path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def main():
    args = parse_args()
    try:
        values = (
            load_values(args.values_file)
            if args.values_file is not None
            else {args.variable: None}
        )
    except OSError as exc:
        print(f"{args.values_file}: {exc.strerror}", file=sys.stderr)
        return 2
    except ValueError as exc:
        print(f"{args.values_file}: {exc}", file=sys.stderr)
        return 2

    files, failed = scan(args.max_depth, DEFAULT_IGNORES.union(args.ignore), values)
    found = set()
    for env_file in files:
        names = dict.fromkeys(assignment.name for assignment in env_file.assignments)
        print(
            f"{env_file.path}: {', '.join(names)} ({len(env_file.assignments)} assignment(s))"
        )
        found.update(names)
    for name in sorted(values.keys() - found):
        print(f"No matches: {name}")
    if not args.apply or not files:
        return int(failed)

    try:
        if args.variable:
            if args.stdin:
                supplied = sys.stdin.read()
                if not supplied:
                    raise ValueError(
                        "stdin is empty. Send a blank line to set an empty value."
                    )
                newline = "\r\n" if supplied.endswith("\r\n") else "\n"
                value = supplied.removesuffix(newline)
                if LINE_BREAK.search(value):
                    raise ValueError("use --values-file for values with line breaks")
            else:
                with interactive_terminal() as (terminal_in, terminal_out):
                    print(
                        f"New value for {args.variable}: ",
                        end="",
                        file=terminal_out,
                        flush=True,
                    )
                    entered = terminal_in.readline()
                    if not entered:
                        raise EOFError
                    value = entered.removesuffix("\n")
            validate_value(value)
            values[args.variable] = value
        encoded = {name: encode_value(values[name]) for name in found}
        if args.confirm:
            with interactive_terminal() as terminal:
                changes = [
                    (env_file, replacement(env_file, encoded, terminal))
                    for env_file in files
                ]
        else:
            changes = [(env_file, replacement(env_file, encoded)) for env_file in files]
    except OSError:
        print(
            "Could not read rotation input or open an interactive terminal.",
            file=sys.stderr,
        )
        return 2
    except (EOFError, KeyboardInterrupt):
        print("Rotation cancelled.", file=sys.stderr)
        return 2
    except UnicodeError:
        print("Rotation input must be valid UTF-8.", file=sys.stderr)
        return 2
    except ValueError as exc:
        print(exc, file=sys.stderr)
        return 2

    for env_file, updated in changes:
        if updated == env_file.source:
            continue
        try:
            atomic_replace(env_file, updated)
        except (OSError, ValueError) as exc:
            message = exc.strerror if isinstance(exc, OSError) else str(exc)
            print(f"{env_file.path}: {message}", file=sys.stderr)
            failed = True
        else:
            print(f"Updated {env_file.path}")
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
