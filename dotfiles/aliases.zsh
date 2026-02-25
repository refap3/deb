# macOS/zsh equivalents of ALIAS.DAT
# Source this file from ~/.zshrc with: source ~/Downloads/aliases.zsh

# Navigation
alias up='cd ..'          # up = cd ..
alias hom='cd ~'         # home = cd \  (root on Windows = home on Mac)
alias home='cd ~'         # home = cd \  (root on Windows = home on Mac)

# Shell
alias lo='exit'           # lo = exit

# Open current directory in Finder (equivalent of: x = explorer /e, /root,%_cwd)
alias x='open .'

# Open file in TextEdit (equivalent of: np = notepad.exe)
alias np='open -e'

# Network info (equivalent of: ia = ipconfig /all)
alias ia='ifconfig'

# more ...
alias sdf='pwd'
alias mov='mv'
alias move='mv'
alias rd='rmdir'
alias md='mkdir'

# Clear screen
alias cls='clear'

# List all files in current directory created/modified today
dt() { find . -maxdepth 1 -newermt "$(date +%Y-%m-%d)" ! -name "." | sort; }

# Show the definition of an alias or function (def <name>)
def() {
    alias "$1" 2>/dev/null || declare -f "$1" || echo "$1: not found"
}

# Find file recursively from current directory (ff <partial name>)
ff()  { find . -not -path "*/.*" -iname "*$1*" 2>/dev/null; }   # skips hidden files/dirs
fff() { find . -iname "*$1*" 2>/dev/null; }                      # includes hidden (dot) files/dirs

