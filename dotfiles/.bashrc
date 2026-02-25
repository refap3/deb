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

source ~/.jump.sh
