#! /bin/bash

#  _____  _____  __   _ __   _ __   __ . _______
#    |   |     | | \  | | \  |   \_/   ' |______
#  __|   |_____| |  \_| |  \_|    |      ______|
#  ______  _______ _______ _     _
#  |_____] |_____| |______ |_____|
#  |_____] |     | ______| |     |
#   _____   ______  _____  _______ _____        _______
#  |_____] |_____/ |     | |______   |   |      |______
#  |       |    \_ |_____| |       __|__ |_____ |______
#######################################################

# source .bashrc if exists
# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

#  ___  ____ ____ _  _ ___  ___
#  |__] |__/ |  | |\/| |__]  |
#  |    |  \ |__| |  | |     |
###############################
NO_COLOR="\\[\\033[0m\\]"
LIGHT_GREY="\\[\\033[37m\\]"
YELLOW="\\[\\033[33m\\]"
BLUE="\\[\\033[34m\\]"
RED="\\[\\033[31m\\]"

function FACE {
  local OUT=$?
  #show happy face
  if [ $OUT -eq 0 ]; then
    echo "$BLUE"^_^ "$NO_COLOR"
  else
    echo "$RED"O_O "$NO_COLOR"
  fi
}

MY_PATH="$YELLOW\\w"

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
GITBRANCH="$LIGHT_GREY $(parse_git_branch)"

emojis=(🐶 🐺 🐱 🐭 🐹 🐰 🐸 🐯 🐨 🐻 🐷 🐮 🐵 🐼 🐧 🐍 🐢 🐙 🐠 🐳 🐬 🐥)
emoji_rand=${emojis[$RANDOM % 22]}
EMOJI="$NO_COLOR$emoji_rand -> "

PS1=$(FACE)$MY_PATH$GITBRANCH$EMOJI


#  ____ _    _ ____ ____
#  |__| |    | |__| [__
#  |  | |___ | |  | ___]
########################

# Commands
alias startpostgres='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppostgres='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias startredis='redis-server /usr/local/etc/redis.conf'
alias update='
    sudo softwareupdate -i -a;
    brew update;
    brew upgrade;
    brew cleanup;
'
alias saver='open -a ScreenSaverEngine'

# git stuff
alias gs='git status '
alias ga='git add '
alias gb='git branch -v'
alias gc='git commit -m'
alias gd='git diff'
alias gco='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias grmall='git rm $(git ls-files -d)'
alias gr='git remote -v'
alias gps='git push'
alias gpso='git push o'
alias gpl='git pull'

alias g='git '
alias gi='git '
alias got='git '
alias get='git '
alias gre='git rebase -i'
alias g-='git checkout -'

# shellcheck source=/dev/null
[ -r ~/git-completion ] && . ~/git-completion.bash

# file navigation
alias l='ls -logGFh'
alias la='ls -logGFrah'
alias c='ccat'
alias ..='cd ..'
alias mkdir='mkdir -pv'
alias rm='rm -v'

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline

# what is my ip
alias myip='curl https://wtfismyip.com/json | jq'

# open up localhost -p
function s(){
    local port="${1:-8000}"
    open "http://localhost:${port}/"
}

#rbenv stuff
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"

most_used_commands() {
    history |
    awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
    grep -v "./" |
    column -c3 -s " " -t |
    sort -nr |
    nl |
    head -n10
}
alias most=most_used_commands

alias crontab="VIM_CRONTAB=true crontab"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:~/apps/nfl-phabricator/arcanist/bin
# shellcheck source=/dev/null
source $HOME/apps/nfl-phabricator/arcanist/resources/shell/bash-completion

# shellcheck source=/dev/null
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*
