# dotfiles
This is a place to save (and possibly share) my configuration files for various programs

Feel free to copy/share whatevery you like!

After cloning:
```bash
ln -s dotfiles/.bash_alias .bash_alias
ln -s dotfiles/.bash_functions .bash_functions
ln -s dotfiles/.emacs .emacs
ln -s dotfiles/.tmux.conf .tmux.conf
# mkdir bin #if not present
ln -s dotfiles/bulkRename.py bin/bulkRename
```
Also make sure that the `bin` directory is added to the `$PATH`.

and add this to you `.bashrc`or `.bash_profile`:
```bash
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

if [ -f ~/.bash_alias ]; then
    source ~/.bash_alias
fi
```
