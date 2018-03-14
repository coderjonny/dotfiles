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
#  ====================================================

# source .bashrc if exists
# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

# use NVIM as default
export VISUAL=/usr/local/bin/nvim
export EDITOR="$VISUAL"

#  ___  ____ ____ _  _ ___  ___
#  |__] |__/ |  | |\/| |__]  |
#  |    |  \ |__| |  | |     |
# ==============================

NO_COLOR="\\[\\033[0m\\]"
LIGHT_GREY="\\[\\033[37m\\]"
YELLOW="\\[\\033[33m\\]"

function print_mood {
  local OUT=$?
  local BLUE="\\033[34m"
  local RED="\\033[31m"
  local NC="\\033[0m"
  local HAPPY_FACE="$BLUE""^_^ $NC"
  local OOPS_FACE="$RED""O_O $NC"

  if [ $OUT -eq 0 ]; then
      printf "$HAPPY_FACE"
  else
      printf "$OOPS_FACE"
  fi
}

MY_PATH="$YELLOW\\w"

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
GITBRANCH="$LIGHT_GREY\$(parse_git_branch)"

emojis=(🐶 🐺 🐱 🐭 🐹 🐰 🐸 🐯 🐨 🐻 🐷 🐮 🐵 🐼 🐧 🐍 🐢 🐙 🐠 🐳 🐬 🐥)
emoji_rand=${emojis[$RANDOM % 22]}
EMOJI="$NO_COLOR $emoji_rand -> "

PS1="\$(print_mood)$MY_PATH$GITBRANCH$EMOJI"

#       _ _
#  __ _| (_)__ _ ___ ___ ___
# / _` | | / _` (_-</ -_|_-<
# \__,_|_|_\__,_/__/\___/__/
# ==========================

# Commands
function update() {
    softwareupdate -i -a;
    brew update;
    brew upgrade;
    brew cleanup;
}

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
alias ...='cd ../../'
alias ....='cd ../../../'
alias mkdir='mkdir -pv'
alias rm='rm -v'

alias ~='cd ~'
alias home='cd ~'
alias tree='tree -C'
alias t='tree -L 2 --filelimit 30 -F --dirsfirst'
tree_example() {
    echo "t -I 'node_modules|coverage' -L 4 -P 'package.*'"
}

# Open the current directory in Finder
alias f='open -a Finder ./'

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

#rbenv stuff
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"

# ____ _  _ _  _
# |--<  \/  |\/|
#---------------
# shellcheck source=/dev/null
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*

#  __ _ _  _ _  _
#  | \|  \/  |\/|
#################
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
        nvm use
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}

# Automatically calls ls after you cd into a directory
cd() { builtin cd "$@"; 'load-nvmrc'; l; }

#            _
#  ____  ___| |__
# |_  / / __| '_ \
#  / / _\__ \ | | |
# /___(_)___/_| |_|
###################
#z script!!!!!!!!!!!!
# shellcheck source=/dev/null
[ -r ~/z.sh ] && . ~/z.sh
[ -r ~/z/z.sh ] && . ~/z/z.sh
# print info when z.shing into a dir
function z() {
    z "$@";
    l;
    printf "\\n";
    gs;
}
alias z=z

export ANDROID_HOME=$HOME/Library/Android/sdk

# Android SDK Tools
export PATH=$PATH:$ANDROID_HOME/tools/bin/

# Android SDK Platform Tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:~/apps/nfl-phabricator/arcanist/bin

ARC=$HOME/apps/nfl-phabricator/arcanist/resources/shell/bash-completion
# shellcheck source=/dev/null
[ -r $ARC ] && . $ARC

#               _         _    _
#  __ _ _ _  __| |_ _ ___(_)__| |
# / _` | ' \/ _` | '_/ _ \ / _` |
# \__,_|_||_\__,_|_| \___/_\__,_|
#################################

alias emulators="\$ANDROID_HOME/tools/emulator -list-avds"

