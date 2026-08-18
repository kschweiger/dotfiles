# Repository Guidelines

## Project Structure & Module Organization

This repository contains personal configuration rather than an installable application. Keep changes in the directory for the tool they affect:

- `zsh/` and `tmux.conf` contain the active shell and multiplexer configuration.
- `LazyVim/` contains the Neovim entry point, Lua configuration, plugins, and `lazy-lock.json`.
- `opencode/`, `term/ghostty/`, and `lazygit_config.yml` contain the active OpenCode, Ghostty, and Lazygit settings.
- `scripts/` contains Python maintenance utilities; `agentic/` contains macOS/agent setup helpers.
- `archive/` holds retired or historical configurations and should not be changed unless explicitly needed.

## Current Stack & Priorities

The primary stack is **Zsh, tmux, Neovim, OpenCode, Ghostty, and Lazygit**. When a request is ambiguous, focus investigation and changes on these tools first. Treat other configuration as supporting or historical unless the request names it directly. Keep each tool’s configuration self-contained and update its nearby README when setup behavior changes.

## Build, Test, and Development Commands

There is no project-wide build command or package manager. Useful checks from the repository root include:

```sh
python3 -m compileall scripts
bash -n agentic/sync_pyenv.sh
zsh -n zsh/zsh_aliases zsh/zsh_functions zsh/zsh_settings
stylua --check LazyVim/lua
```

Run only the checks relevant to the files changed. If Neovim is available, launch the configuration with `nvim -u LazyVim/init.lua` and verify affected plugins, mappings, and diagnostics interactively.

## Coding Style & Naming Conventions

Use two spaces for Lua, with the repository’s 120-column `LazyVim/stylua.toml` configuration. Use four spaces and readable `snake_case` names in Python. Shell variables and functions should follow the surrounding file’s convention; Bash helpers should retain strict mode (`set -euo pipefail`). Preserve existing tool-specific filenames such as `zsh_aliases`, `settings.json`, and `lazy-lock.json`.

## Testing Guidelines

No formal test framework or coverage threshold is configured. Treat syntax/format checks as required for changed code, then manually test linked or loaded configuration in the relevant application. For UI/editor settings, include a screenshot or a short reproduction note when behavior is not obvious.

## Commit & Pull Request Guidelines

Recent commits use concise component prefixes, for example `[nvim] update lock` and `[opencode] Add bedrock provider`. Follow that pattern: `[component] imperative summary`. Pull requests should explain the user-visible configuration change, list validation performed, identify platform-specific assumptions, and call out lockfile or generated-file updates. Never commit credentials, tokens, private paths, or machine-specific secrets.
