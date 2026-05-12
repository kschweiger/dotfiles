# Opencode configuration

The `opencode.json` is the global config to be placed (or linked) as `~/.config/opencode/opencode.json`

## Examples:

Using the pyright language server installed with mason in nvim

```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "pyright": {
      "disabled": true,
    },
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
    }
  }
}
```


and then also add a pyright config to the project root:

```json
{
  // Keep this config where opencode reports the Pyright root:
  // root=...
  //
  // This avoids relying on opencode's LSP initialization payload,
  // because Pyright reliably reads pyrightconfig.json as project config.
  "venvPath": "absolute/path/to/venv",
  "venv": "venv_name",
  // Use the language version, not the interpreter path.
  "pythonVersion": "3.12",
  // Optional, useful while debugging import resolution.
  "verboseOutput": true
}
```


you can test it with  

```bash
opencode debug lsp diagnostics --print-logs --log-level=DEBUG  path/to/file.py
```
