# Zsh configuration

General setup uses [Oh-My-Zsh](https://ohmyz.sh/#install) with the [Powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh) theme.

## Additional plugins

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete?tab=readme-ov-file#installation--setup)
- [autoupdate](https://github.com/tamcore/autoupdate-oh-my-zsh-plugins)

## Intended usage of files

The files

```bash
zsh_aliases
zsh_functions
zsh_settings
```

are intended to be sources in the `.zshrc`.

## Additonal tooling

### Brew

Add this snipped to the `.zprofile` for a regular update promt similar to oh-my-zsh for your homebrew package manager

```bash
if [ -f "$HOME/dotfiles/zsh/brew_autoupdate.zsh" ]; then
  source "$HOME/dotfiles/zsh/brew_autoupdate.zsh"
  
  # Run the update check
  auto_update_brew
fi
```

### Tooling installed with cargo

Add this snipped to the `.zprofile` for a regular update promt similar to oh-my-zsh for your tools installed with cargo. 
In this case you have to specify which tools to update. Tolls that are listed but not installed, will not be installed.


```bash
if [ -f "$HOME/dotfiles/zsh/cargo_update.zsh" ]; then
  source "$HOME/dotfiles/zsh/cargo_update.zsh"

  # Define the list of cargo tools you want to keep updated
  local cargo_tools_to_update=(
    "tree-sitter-cli"
    "tailspin"
  )
  
  # Run the update check for the specified tools
  auto_update_cargo_tools "${cargo_tools_to_update[@]}"
fi

```
