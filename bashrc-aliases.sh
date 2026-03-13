#!/usr/bin/env bash
# Shell aliases and functions
# General-purpose and project-specific shortcuts

# Display and navigation
alias ls='ls --show-control-chars -F --color $*'
alias pwd='cd'
alias clear='cls'
alias vi='vim $*'
alias ci='code-insiders $*'

# Git aliases
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

# Rush build functions
rb() {
  rush install && rush build "$@" && echo Finished at "$(date)"
}

rbt() {
  rush install && rush build --to "$@" && echo Finished at "$(date)"
}

rbtd() {
  rush install && rush build --to "$@" && rush dev-deploy --to "$@" && echo Finished at "$(date)"
}

# AI Properties Web Part shortcuts
rbw() {
  rush install && rush build --to tag:ai-properties-web-part "$@" && echo Finished at "$(date)"
}

rsw() {
  rush start --to tag:ai-properties-web-part "$@"
}

rdw() {
  rush dev-deploy --to tag:ai-properties-web-part "$@" && echo Finished at "$(date)"
}

rba() {
  rush build -o sp-ai-properties -o sp-ai-properties-tools -o sp-ai-properties-tools-internal -o sp-canvas-vibe
}

rbai() {
  rush install && rush build --to tag:ai-properties-web-part --to sp-pages --to sp-canvas-vibe && rush dev-deploy --to tag:ai-properties-web-part --to sp-pages --to sp-canvas-vibe && echo Finished at "$(date)"
}

rbaia() {
  rush install && rush build -t tag:chatodsp-pages -t sp-pages && rush dev-deploy -t tag:chatodsp-pages -t sp-pages
}

# Git function for user branches
gcb() {
  git checkout -b "user/liaye/$@"
}

# NPM build and deploy
nb() {
  npm run _phase:build:incremental "$@"
}

alias nbs='npm run _phase:build:incremental -- --source-maps'
alias nd='npm run deploy'
alias ndr='npm run deploy -- --rush'
alias nbd='npm run _phase:build:incremental && npm run deploy'
alias nbsd='npm run _phase:build:incremental -- --source-maps && npm run deploy'
alias nbdr='npm run _phase:build:incremental && npm run deploy -- --rush'
alias nbsdr='npm run _phase:build:incremental -- --source-maps && npm run deploy -- --rush'
alias nt='npm run tab -- --browser=ie --noAutoRun'
alias ntr='npm run tab -- --rush'
alias nbtr='npm run _phase:build && npm run tab -- --rush'

# Microsoft-specific shortcuts
alias cmderr='cd /d "%CMDER_ROOT%"'
alias up='git checkout origin/main -- ../../../common/config/rush/pnpm-lock.yaml'
alias upa='git checkout origin/main -- ../../../common/config/rush'
alias rebuild='rush update && rush rebuild && echo Finished at %date% %time%'
alias unalias='alias /d $1'
