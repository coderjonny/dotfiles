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



# use NVIM as default
export VISUAL=/usr/local/bin/nvim
export EDITOR="$VISUAL"
export POSTGREST_HOST=35.203.146.107

#  ___  ____ ____ _  _ ___  ___
#  |__] |__/ |  | |\/| |__]  |
#  |    |  \ |__| |  | |     |
# ==============================

NO_COLOR="\\[\\033[0m\\]"
LIGHT_GREY="\\[\\033[37m\\]"
YELLOW="\\[\\033[33m\\]"

function print_mood {
  local OUT="$?"
  local BLUE="\\[\\033[34m\\]"
  local RED="\\[\\033[31m\\]"
  local NC="\\[\\033[0m\\]"

  if [ $OUT -eq 0 ]; then
      printf "%s\n" "$BLUE ^.^ $NC"
  else
      printf "%s\n" "$RED O.O $NC"
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

set_bash_prompt(){
    PS1="$(print_mood)$MY_PATH$GITBRANCH$EMOJI"
}

PROMPT_COMMAND=set_bash_prompt

# bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

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

# show port info
# usage: p 8081
p ()
{
  lsof -i tcp:"$1";
}

alias p=p

# git stuff
alias gs='git status '
alias ga='git add '
alias gb='git branch -v -v'
alias gc='git commit -m'
alias gd='git diff'
alias gco='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias grmall='git rm $(git ls-files -d)'
alias gr='git remote -v'
alias gps='git push'
alias gp='git push'
alias gpso='git push o'
alias gpl='git pull'
alias gcp='git cherry-pick'

alias g='git '
alias gi='git '
alias got='git '
alias get='git '
alias gre='git rebase -i'
alias g-='git checkout -'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# shellcheck source=/dev/null
[ -r ~/git-completion ] && . ~/git-completion.bash

# file navigation
alias l='exa -lhF --git'
alias la='exa -lahF --git'
alias c='ccat'
alias b='bat'
alias cat='bat'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias mkdir='mkdir -pv'
alias rm='rm'
alias e='exa -lh --git'

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

export PATH="/usr/local/opt/ruby/bin:$PATH"
if command -v ruby >/dev/null && command -v gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

#rbenv stuff
if command -v rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"

# ____ _  _ _  _
# |--<  \/  |\/|
#---------------
# shellcheck source=/dev/null
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*

#  __ _ _  _ _  _
#  | \|  \/  |\/|
#################
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
        nvm use
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}

# Automatically calls ls after you cd into a directory
cd() {
    builtin cd "$@" || return;
    'load-nvmrc';
    l;
}

eval "$(lua ~/z.lua --init bash enhanced once fzf)"
export _ZL_ECHO=1

function zo() {
    z "$@";
    printf "\\n";
    exa -lhF --git;
    printf "\\n";
    gs;
}
alias z='zo'
alias zz='z -c'      # restrict matches to subdirs of $PWD
alias zi='z -I'      # cd with interactive selection
alias zb='z -b'      # quickly cd to the parent directory


#               _         _    _
#  __ _ _ _  __| |_ _ ___(_)__| |
# / _` | ' \/ _` | '_/ _ \ / _` |
# \__,_|_||_\__,_|_| \___/_\__,_|
#################################
export ANDROID_HOME=$HOME/Library/Android/sdk

# Android SDK Tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

# Android SDK Platform Tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/emulator

export PATH=$PATH:~/apps/nfl-phabricator/arcanist/bin
alias emulator="\$ANDROID_HOME/tools/emulator"
alias emulators="\$ANDROID_HOME/tools/emulator -list-avds"
alias run-emulator='emulator @$(emulators)'


ARC=$HOME/apps/nfl-phabricator/arcanist/resources/shell/bash-completion
# shellcheck source=/dev/null
[ -r "$2ARC" ] && . "$ARC"

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# source .bashrc if exists
# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

# ____    ____  ___      .______      .__   __.
# \   \  /   / /   \     |   _  \     |  \ |  |
#  \   \/   / /  ^  \    |  |_)  |    |   \|  |
#   \_    _/ /  /_\  \   |      /     |  . `  |
#     |  |  /  _____  \  |  |\  \----.|  |\   |
#     |__| /__/     \__\ | _| `._____||__| \__|
################################################
## alias   yy='yarn && yarn bootstrap'
alias  yyy='yarn reset && yarn && yarn bootstrap'

alias yyi='yarn && yarn bootstrap && yarn ios'
alias yyo='yarn && yarn bootstrap && yarn ios --app NFLMobile --simulator="iPhone 7 Plus"'
alias yyof='yarn && yarn bootstrap && yarn ios --app FacemaskReference'

alias  yya='yarn && yarn bootstrap && yarn android'
alias yya='yarn && yarn bootstrap && yarn android --app NFLMobile'
alias yyaf='yarn && yarn bootstrap && yarn android --app FacemaskReference'

alias yi='yarn ios --simulator="iPhone 8"'

alias yy='yarn && cd ios && pod install && ..'

# DEEPLINKING
alias deeplink='xcrun simctl openurl booted '

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH="/usr/local/sbin:$PATH"

alias n=nvim
