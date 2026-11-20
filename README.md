# dotfiles

This is a place to save (and possibly share) my configuration files for various programs

Feel free to copy/share whatever you like!

After cloning:

```shell
ln -s dotfiles/zsh/zsh_settings .zsh_settings
ln -s dotfiles/zsh/zsh_functions .zsh_functions
ln -s dotfiles/zsh/zsh_aliases .zsh_aliases

ln -s dotfiles/tmux.conf .tmux.conf
```

Don't forget to update the `.zshrc` accordingly with something like:

```shell
source ~/.zsh_aliases
source ~/.zsh_functions
source ~/.zsh_settings
```

## tmux

### Prerequisites

1. tmux is installed 🙃
2. Install [TPM](https://github.com/tmux-plugins/tpm)
3. Link the config to `$HOME`
4. Start tmux and run the TPM install command (Leader + I)

## zsh

See [zsh readme](zsh/README.md) for more details.

## VS-Code

See [vs-code readme](vscode/README.md) for more details.

# Other tools

## Rotate `.env` values

Run `scripts/rotate_env.py` from the directory you want to search. The examples
assume the script is on your PATH. You can also invoke it by its absolute path.
It requires Python 3.13 or later.

```sh
rotate_env.py AZURE_KEY                          # preview matching files
rotate_env.py AZURE_KEY --apply --confirm        # enter the new value, then review each match
rotate_env.py --values-file rotation.json        # preview a batch
rotate_env.py --values-file rotation.json --apply --confirm
```

The JSON file maps variable names to strings. It can be formatted across
multiple lines. Use `\n` inside a JSON string to insert a line break in the value.

```json
{
  "AZURE_KEY": "example-token",
  "PRIVATE_KEY": "first line\nsecond line"
}
```

Keep that file out of version control. In single-variable mode, `--apply` prompts
for the new value and shows it as you type. Add `--stdin` to read one value from a pipe.

`--confirm` shows the current value in the terminal for each proposed change.
Type `y` to replace it or press Enter to skip it. The script collects all answers
before writing. Each accepted occurrence of a variable receives the same new value
for that run.

The search includes the current directory at depth 0 and goes to depth 3.
Use `--max-depth N` to change the limit and repeat `--ignore NAME` to skip
additional directory names. The defaults skip `.git`, `.venv`, `venv`,
`node_modules`, `__pycache__`, and symbolic links. The script updates existing
assignments in files named exactly `.env`, including quoted multiline values.
Values that need quoting use shell-style escaping.

## Tooling

- [nvim](https://github.com/neovim/neovim/releases)
- [treesitter cli](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [bat](https://github.com/sharkdp/bat) to replace `cat` in the terminal
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- Lang tooling
  - [pyenv](https://github.com/pyenv/pyenv) for python version management
  - [nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script) Node version management

# Notes

## ssh

Github provides a way to [use ssh over the https port](https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port) which can be used to interact with Github repos using usual ssh setups (ssh-keys, `git@github.com` remotes, ...).

For this you have to add the following to your ssh config:

```
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
```

This can be tested with `ssh -T -p 443 git@ssh.github.com`. If you are behind a proxy, add

```
    ProxyCommand nc -X connect -x PROXYHOST:PROXYPORT %h %p
```

to the host. `nc` also support authentification if necessary.

