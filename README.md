# dotfiles
This is a place to save (and possibly share) my configuration files for various programs

Feel free to copy/share whatevery you like!

After cloning:
```shell 
ln -s dotfiles/zsh/zsh_settings .zsh_settings
ln -s dotfiles/zsh/zsh_functions .zsh_functions
ln -s dotfiles/zsh/zsh_aliases .zsh_aliases

ln -s dotfiles/.tmux.conf .tmux.conf
```

Don't forget to update the `.zshrc` accordingly with something like:
```shell 
source ~/.zsh_aliases
source ~/.zsh_functions
source ~/.zsh_settings
```



## tmux

### Prerequisites

1. tmux is install 🙃
2. Istall [TPM](https://github.com/tmux-plugins/tpm)
