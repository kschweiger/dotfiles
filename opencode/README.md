# Opencode configuration

The `opencode.json` is the global config to be placed (or linked) as `~/.config/opencode/opencode.json`

## Examples:

Using the pytright langserver istalled with mason in nvim

```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "pyright-nvim": {
      "disabled": false,
      "command": [
        "/absolute/path/to/.local/share/nvim/mason/bin/pyright-langserver",
        "--stdio",
      ],
      "extensions": [
        ".py",
        ".pyi"
      ],
      // "env": {
      //   "VIRTUAL_ENV": "/absolute/path/to/.venv/"
      // },
      "initialization": {
        "pythonPath": "/absolute/path/to/.venv/bin/python",
        "pythonVersion": "3.14",
        "venvPath": "/absolute/path/to/",
        "venv": ".venv"
      }
    }
  }
}
```

