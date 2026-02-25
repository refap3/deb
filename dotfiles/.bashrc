export PATH="$HOME/.local/bin:$PATH"

# Resolve DOTFILES to the directory where this file actually lives,
# following the symlink if one exists. readlink is available on macOS
# without any extra tools; dirname handles the rest.
_t=$(readlink "$HOME/.bashrc" 2>/dev/null)
DOTFILES=$(dirname "${_t:-$HOME/.bashrc}")
unset _t

# Aliases — load all *alias*.zsh files
for _f in "$DOTFILES"/*alias*.zsh; do [ -f "$_f" ] && source "$_f"; done
unset _f

gital() {
    source ~/.gitalias.zsh
    echo "Git aliases loaded!"
}

# Reload all aliases fresh
allal() {
    unalias -a
    for _f in "$DOTFILES"/*alias*.zsh; do [ -f "$_f" ] && source "$_f"; done
    unset _f
    echo "All aliases reloaded."
}

# Unload git aliases and reload profile (bash equivalent of zsh sl)
sl() {
    unalias -a
    unset -f gs 2>/dev/null
    source ~/.bashrc
    echo ". sl executed! (Profile reloaded, Git aliases unloaded)"
}

source ~/.jump.sh
