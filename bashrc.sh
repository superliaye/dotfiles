alias gl='git log --oneline --all --graph --decorate  $*'
alias ls='ls --show-control-chars -F --color $*'
alias pwd='cd'
alias clear='cls'
alias unalias='alias /d $1'
alias vi='vim $*'
alias cmderr='cd /d "%CMDER_ROOT%"'
alias rebuild='rush update && rush rebuild && echo Finished at %date% %time%'
rb() {
  rush install && rush build "$@" && echo Finished at "$(date)"
}

rbt() {
  rush install && rush build --to "$@" && echo Finished at "$(date)"
}
rbw() {
  rush install && rush build --to sp-canvas-edit --to sp-people-webparts --to sp-image-webparts --to sp-image-webpart-next --to sp-divider-webpart --to sp-spacer-webpart --to sp-quicklinks-webparts "$@" && echo Finished at "$(date)"
}
rsw() {
  rush start --to sp-canvas-edit --to sp-people-webparts --to sp-quicklinks-webparts --to sp-image-webparts --to sp-image-webpart-next --to sp-divider-webpart --to sp-spacer-webpart "$@"
}

rdw() {
  rush dev-deploy --to sp-canvas-edit --to sp-people-webparts --to sp-quicklinks-webparts --to sp-image-webparts --to sp-image-webpart-next --to sp-divider-webpart --to sp-spacer-webpart "$@"
}

alias rba='rush build -o sp-ai-properties -o sp-ai-properties-tools -o sp-ai-properties-tools-internal'
alias gp='git pull origin --prune'
alias gps='git push origin $*'
alias gcm='git checkout main'
gcb() {
  git checkout -b "user/liaye/$@"
}
alias ga='git add -A'
alias gs='git status'
alias gmm='git merge main'
alias gc='git gc --prune=now && git remote prune origin'
alias gf='git fetch origin'
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
alias ci='code-insiders $*'
alias up='git checkout origin/main -- ../../../common/config/rush/pnpm-lock.yaml'
alias upa='git checkout origin/main -- ../../../common/config/rush'

# start-transpile-c() {
#   rush start --to sp-transpile --to sp-transpile-components --to sp-renderable-components-base "$@"
# }

# git config --global core.editor "vi"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
