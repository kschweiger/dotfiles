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
