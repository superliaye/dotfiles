#!/usr/bin/env bash
# General shell aliases and functions
# Independent of any specific project or company

# Display and navigation
alias ls='ls --show-control-chars -F --color $*'
alias pwd='cd'
alias clear='cls'
alias vi='vim $*'
alias ci='code-insiders $*'

# Git aliases - universal
alias gl='git log --oneline --all --graph --decorate  $*'
alias gp='git pull origin --prune'
alias gps='git push origin $*'
alias gcm='git checkout main'
alias ga='git add -A'
alias gs='git status'
alias gmm='git merge main'
alias gc='git gc --prune=now && git remote prune origin'
alias gf='git fetch origin'

# Git config - pretty log format
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
