#!/usr/bin/env python3
import json
import platform
import re
import subprocess
import urllib.request
from pathlib import Path


def main():
    home = Path.home()

    version = subprocess.check_output(["lazygit", "--version"], text=True, cwd=home)

    version_match = re.search(r"version=([^,]+)", version)

    if version_match:
        version = version_match.group(1)
        print(f"Extracted LazyGit version: {version}")
    else:
        print("Version could not be extracted")
        exit(1)

    res = urllib.request.urlopen(
        "https://api.github.com/repos/jesseduffield/lazygit/releases/latest"
    )
    data = json.loads(res.read().decode())
    latest_tag = data["tag_name"]

    if latest_tag.replace("v", "") == version:
        print("LazyGit is up to date")
        exit(0)
    else:
        print("Found new version: %s" % latest_tag)

    system = platform.system().lower()  # 'Linux', 'Windows', 'Darwin' (for macOS)
    machine = platform.machine().lower()  # 'x86_64', 'amd64', 'arm64', etc.
    print(f"System: {system}, Architecture: {machine}")

    match system, machine:
        case "linux", "x86_64":
            _asset = [
                a
                for a in data["assets"]
                if system in a["name"].lower()
                and machine in a["name"].lower()
                and a["name"].endswith("tar.gz")
            ]
            assert len(_asset) == 1, f"Expected 1 asset, found {len(_asset)}"
            asset = _asset[0]
        case "linux", "aarch64":
            _asset = [
                a
                for a in data["assets"]
                if system in a["name"]
                and "arm64" in a["name"]
                and a["name"].endswith("tar.gz")
            ]
            assert len(_asset) == 1, f"Expected 1 asset, found {len(_asset)}"
            asset = _asset[0]
        case _:
            print(f"System: {system}, Architecture: {machine} not supported")
            exit(1)

    download_url = asset["browser_download_url"]

    filename = download_url.split("/")[-1]
    try:
        subprocess.run(
            ["curl", "-L", download_url, "-o", filename], check=True, cwd=home
        )
        print("Successfully downloaded archive")
    except subprocess.CalledProcessError as e:
        print(f"Failed to download: {e}")
        exit(1)

    try:
        # Use tar command via subprocess to extract
        subprocess.run(
            ["tar", "-xzf", str(filename), "-C", f"{home}/.local/bin/"],
            check=True,
            cwd=home,
        )
        print("Successfully extracted archive")

        # Optional: Remove the tar.gz file after extraction
        subprocess.run(["rm", str(filename)], check=True, cwd=home)
        subprocess.run(["rm", f"{home}/.local/bin/LICENSE"], check=True, cwd=home)
        subprocess.run(["rm", f"{home}/.local/bin/README.md"], check=True, cwd=home)
        print(f"Removed downloaded archive: {filename}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to extract: {e}")
        exit(1)


if __name__ == "__main__":
    main()
