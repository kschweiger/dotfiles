# NeoVim config

## Requirements

- neovim >= 0.10
- [ripgrep](https://github.com/BurntSushi/ripgrep) is required by the `telescope` integration of the `todo-comments` plugin
- [fd](https://github.com/sharkdp/fd) is required by the `venvselect` plugin
- [node](https://nodejs.org/en) required for third party programs like
  - [pyright](https://microsoft.github.io/pyright/#/)
- Link this folder to `$HOME/.config/`

## MacOS and iTerm2

- Create a profile for NeoVim
- If backspace does not work, delete all "delete" related entries in Profile -> Key -> Key-Mappings
- Set the the left option key to META in Profile -> Keys -> General

## Python development

- Lsp setup uses `pyright` + `ruff`
- To deal with multi-repo projects (meaning on directroy that contains multiple python package repos and each is installed as editable package) required a bit of a special setup:
  - None of the repos should have a `pyrightconfig.json` file.
  - Create a `pyproject.toml` in the root directroy with your `ruff` setup
  - Create a `pyrightconfig.json` with the package repos as `extraPaths`. This works because the search order in the lsp-config. Example:
    ```json
    {
      // "venv": "some_venv",
      // "venvPath": "/some/path/to/.pyenv/versions",
      "extraPaths": ["./package_1/", "./package_2/"],
      "exclude": [
        "**/node_modules",
        "**/__pycache__",
        "src/experimental",
        "src/typestubs",
        "*mlruns",
        "**/outputs"
      ]
    }
    ```
