# Git Aliases (Converted from PowerShell)

# Complex function for 'gs' (Status + Fetch + Diff Main)
gs() {
    git status -s "$@"
    git fetch "$@"
    git diff main origin/main "$@"
}

# Standard Aliases
alias gi='git init'
alias gcl='git clone'
alias ga='git add'
alias gc='git commit -m'
alias gac='git commit -a -m'
alias gaca='git commit -a --amend'
alias gch='git checkout'
alias gb='git branch'
alias gm='git merge'
alias gdi='git diff'
alias gdin='git diff --name-only'
alias gt='git tag'
alias gl='git log --decorate --graph --all'
alias glo='git log --oneline'
alias glf='git log --'
alias glfp='git log -p --'
alias grh='git reset HEAD --hard'
alias gre='git reset'
alias gdt='git difftool'
alias gpl='git pull'
alias gps='git push origin main --tags'
alias gf='git fetch'
alias gdm='git diff main origin/main'
alias gk='gitk'
alias gr='git remote -v'
alias grs='git remote set-url origin'
alias gbl='git blame'
alias gbis='git bisect start'
alias gbir='git bisect reset'
alias gbig='git bisect good'
alias gbib='git bisect bad'
alias gst='git stash'
alias gstp='git stash pop'
alias grl='git reflog'

# Notes:
# 'gconf' was skipped because it pointed to a Windows path (K:\scripts\...)
