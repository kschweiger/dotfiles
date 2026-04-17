# Opencode configuration

The `opencode.json` is the global config to be placed (or linked) as `~/.config/opencode/opencode.json`

## Examples:

Using the pytright langserver istalled with mason in nvim

```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "pyright": {
      "disabled": true,
      "command": [
        "~/.local/share/nvim/mason/bin/pyright-langserver",
        "--stdio",
      ],
      "env": {
        "VIRTUAL_ENV": "/path/to/venv/base/"
      }
    }
  }
}

```

