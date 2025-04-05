#!/usr/bin/env bash

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
export VISUAL=/opt/homebrew/bin/nvim
export EDITOR="$VISUAL"
export POSTGREST_HOST=35.203.146.107
alias n=nvim

 if [ -d "/usr/local/opt/ruby/bin" ]; then
   export PATH=/usr/local/opt/ruby/bin:$PATH
   export PATH=`gem environment gemdir`/bin:$PATH
 fi

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
alias ss='open -a ScreenSaverEngine'

# show port info
# usage: p 8081
p ()
{
  lsof -i tcp:"$1";
}

alias p=p

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# git stuff
alias gs='git status '
alias ga='git add '
alias gb='git branch -vv'
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
alias gprune="git remote update origin --prune"

# shellcheck source=/dev/null
test -f ~/.git-completion.bash && . "$_"

# file navigation
alias l='eza -lhF --git'
alias la='eza -lahF --git'
alias c='bat'
alias b='bat'
alias cat='bat'
alias mkdir='mkdir -pv'
alias rm='rm'
alias e='eza -lh --git'

alias o='open'
alias md='open -a macdown'

alias ~='cd ~'
alias home='cd ~'
alias tree='tree -C'
alias t='tree -L 2 --filelimit 30 -F --dirsfirst'
tree_example() {
    echo "t -I 'node_modules|coverage' -L 4 -P 'package.*'"
}

# Open the current directory in Finder
alias f='open -a Finder ./'

# LESS Colors for Man Pages
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

# vtop, better top
alias vtop="vtop --theme brew"

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

# ____ _  _ _  _
# |--<  \/  |\/|
#---------------
# shellcheck source=/dev/null
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*

#  __ _ _  _ _  _
#  | \|  \/  |\/|
#################
# export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# load-nvmrc() {
#     if [[ -f .nvmrc && -r .nvmrc ]]; then
#         nvm use
#     elif [[ $(nvm version) != $(nvm version default)  ]]; then
#         echo "Reverting to nvm default version"
#         nvm use default
#     fi
# }

# Automatically calls ls after you cd into a directory
# cd() {
#     builtin cd "$@" || return;
#     # 'load-nvmrc';
#     l;
# }


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

alias emulator="\$ANDROID_HOME/tools/emulator"
alias emulators="\$ANDROID_HOME/tools/emulator -list-avds"
alias run-emulator='emulator @$(emulators)'

# ____    ____  ___      .______      .__   __.
# \   \  /   / /   \     |   _  \     |  \ |  |
#  \   \/   / /  ^  \    |  |_)  |    |   \|  |
#   \_    _/ /  /_\  \   |      /     |  . `  |
#     |  |  /  _____  \  |  |\  \----.|  |\   |
#     |__| /__/     \__\ | _| `._____||__| \__|
################################################
alias y='yarn'
alias yy='yarn && cd ios && pod install && ..'
alias yyi='yarn && cd ios && pod install && .. && y ios && y start'
alias yyd='yarn && cd ios && pod install && .. && y ios --device && y start'
alias yya='yarn && y android'
alias yyy='yarn reset && yarn && yarn bootstrap'

# DEEPLINKING
alias deeplink='xcrun simctl openurl booted '

# source .bashrc if exists
# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# adds brew to path
 eval "$(/opt/homebrew/bin/brew shellenv)"
# alias oldbrew='arch -x86_64 /usr/local/homebrew/bin/brew'

# export PATH="/Users/jonny/Library/Python/3.7/bin:$PATH"


# rbenv
# eval "$(rbenv init -)"
# export PATH="/usr/local/homebrew/bin:$PATH"



# Simple calculator
function calc() {
        local result=""
        result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
        #                       └─ default (when `--mathlib` is used) is 20
        #
        if [[ "$result" == *.* ]]; then
                # improve the output for decimal numbers
                printf '\n     %s\n' "$result" |
                sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
                    -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
                    -e 's/0*$//;s/\.$//'   # remove trailing zeros
        else
                printf '\n     %s\n' "$result"
        fi
        printf "\n"
}

# look up words - with define
define() {
  open dict://"${1}"
}
d () {
  define "$1"
}



# Setup z
eval "$(lua ~/z.lua --init bash enhanced once fzf)"
export _ZL_ECHO=1

function zo() {
    z "$@";
    printf "\\n";
    eza -lhF --git;
    printf "\\n";
    gs;
}
alias z='zo'
alias zz='z -c'      # restrict matches to subdirs of $PWD
alias zi='z -I'      # cd with interactive selection
alias zb='z -b'      # quickly cd to the parent directory
