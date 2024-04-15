# dotfiles
This is a place to save (and possibly share) my configuration files for various programs

Feel free to copy/share whatever you like!

After cloning:
```shell 
ln -s dotfiles/zsh/zsh_settings .zsh_settings
ln -s dotfiles/zsh/zsh_functions .zsh_functions
ln -s dotfiles/zsh/zsh_aliases .zsh_aliases
ln -s dotfiles/zsh/p10k.zsh .p10k.zsh

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
3. Link the config to `$HOME


## zsh

See [zsh readme](zsh/README.md) for more details.

## VS-Code

See [vs-code readme](vscode/README.md) for more details.

# Other tools

## Essentials

- [pyenv](https://github.com/pyenv/pyenv) for python version management
- [bat](https://github.com/sharkdp/bat) to replace `cat` in the terminal

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