export PATH="$HOME/.local/bin:$PATH"

DOTFILES="${${:-$HOME/.zshrc}:A:h}"

# Aliases — load all *alias*.zsh files
for _f in "$DOTFILES"/*alias*.zsh; do [[ -f "$_f" ]] && source "$_f"; done
unset _f

# Delayed Git Alias Loader
function gital() {
    source ~/.git_aliases
    echo "Git aliases loaded! (Use 'gh' for help if you have a helper function, or just use the aliases)"
}

# Optional: Helper function to list these specific aliases (similar to your 'gh')
function gh() {
    cat ~/.git_aliases | grep '^alias' | sort
}
# Reload all aliases fresh
function allal() {
    unalias -a
    for _f in "$DOTFILES"/*alias*.zsh; do source "$_f"; done
    unset _f
    echo "All aliases reloaded."
}

# Cleanup Function (Equivalent to your PowerShell 'sl')
function sl() {
    # 1. AGGRESSIVE CLEANUP
    # Unalias all 2-4 letter commands starting with 'g' (ga, gaca, etc.)
    # We use 'unalias -m' which supports patterns
    unalias -m 'g[a-z]'      # ga, gb, gc...
    unalias -m 'g[a-z][a-z]'   # gcl, gco...
    unalias -m 'g[a-z][a-z][a-z]' # gaca, gdin...

    # 2. Unfunction specific git functions (like gs)
    unfunction gs 2>/dev/null

    # 3. RELOAD PROFILE
    # Now that we are clean, we reload the base config.
    # Since we fixed Step 1, this will NOT reload the git aliases.
    source ~/.zshrc

    echo ". sl executed! (Profile reloaded, Git aliases unloaded)"
}

source ~/.jump.sh
