# .bash_profile
# source .bashrc if exists
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

#bash script to without showing happy face
#PS1="[\[\033[32m\]\w]\[\033[0m\] \[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\]"

#show happy face
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
user="\[\033[1;36m\]\u\[\033[1;33m\]"

#time_prompt='\D{%F %T}\n\$ '
#now=$(date +"%I:%M%p")" "

face="\`if [ \$? = 0 ]; then echo \[\e[33m\]^_^\[\e[0m\]; else echo \[\e[31m\]O_O\[\e[0m\]; fi\` "

path="\[\033[32m\]\w \[\033[0m\]"

emojis=(🐶 🐺 🐱 🐭 🐹 🐰 🐸 🐯 🐨 🐻 🐷 🐮 🐵 🐼 🐧 🐍 🐢 🐙 🐠 🐳 🐬 🐥)
emoji_rand=${emojis[$RANDOM % ${#emojis[@]} ]}

gitbranch="\$(parse_git_branch)$emoji_rand -> \[\033[0m\]"

#daniel's PS1
#PS2="\[\e[32m\]\$(parse_git_branch)\[\e[34m\]\h:\W \$ \[\e[m\]"
#export PS2

PS1=$face$path$gitbranch

# Commands
alias startpostgres='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppostgres='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias startredis='redis-server /usr/local/etc/redis.conf'
alias app='bundle exec'
alias color='git config color.ui true'

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
alias grd='git rebase -i development'
alias gback='git checkout -'
alias gdev='git pull o development'

#testing stuff
alias cuke='bundle exec cucumber'
alias rspec='bundle exec spring rspec'

export CC=gcc
function path(){
  old=$IFS
  IFS=:
  printf "%s\n" $PATH
  IFS=$old
}

function s(){
  local port="${1:-8000}"
  open "http://localhost:${port}/"
}

function cdb
{
  local TIMES=$1
  local INITIAL=1
  local BACK_DIR='../'
  local DIRS

  if [ $# -eq 0 ]; then
    DIRS[0]="${BACK_DIR}"
  fi

  for ((i=INITIAL;i<=TIMES;i++)); do
    DIRS=("${DIRS[@]}" "${BACK_DIR}")
  done

  cd `printf "%s" "${DIRS[@]}"`
}


#rbenv stuff
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=${PATH}:$HOME/gsutil

# file navigation
alias l='ls -logGFh'
alias la='ls -logGFrah'
alias c='ccat'


export NVM_DIR="/Users/jonnykang/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#source "$HOME/imgcat"
alias crontab="VIM_CRONTAB=true crontab"

load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

cd() { builtin cd "$@"; 'load-nvmrc'; }
###-begin-graphql-completions-###
#
# yargs command completion script
#
# Installation: graphql completion >> ~/.bashrc
#    or graphql completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(graphql --get-yargs-completions "${args[@]}")

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
    fi

    return 0
}
complete -F _yargs_completions graphql
###-end-graphql-completions-###

alias update='sudo softwareupdate -i -a; brew update; brew upgrade --all;
  brew cleanup; npm install npm -g; npm update -g; sudo gem update --system;
  sudo gem update;rbenv rehash;'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export ANDROID_HOME=~/Library/Android/sdk
export PATH=/Users/jonnykang/.rvm/gems/ruby-2.4.1/bin:/Users/jonnykang/.rvm/gems/ruby-2.4.1@global/bin:/Users/jonnykang/.rvm/rubies/ruby-2.4.1/bin:/Users/jonnykang/.nvm/versions/node/v8.9.1/bin:/Users/jonnykang/.rbenv/bin:/Users/jonnykang/.rbenv/shims:/usr/local/bin:/Users/jonnykang/bin:/usr/local/heroku/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin:/usr/local/bin:/Users/jonnykang/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/jonnykang/gsutil:/Users/jonnykang/.rvm/bin:/tools:/platform-tools
export ANDROID_HOME=~/Library/Android/sdk
export PATH=/Users/jonnykang/.rvm/gems/ruby-2.4.1/bin:/Users/jonnykang/.rvm/gems/ruby-2.4.1@global/bin:/Users/jonnykang/.rvm/rubies/ruby-2.4.1/bin:/Users/jonnykang/.nvm/versions/node/v8.9.1/bin:/Users/jonnykang/.rbenv/bin:/Users/jonnykang/.rbenv/shims:/usr/local/bin:/Users/jonnykang/bin:/usr/local/heroku/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin:/usr/local/bin:/Users/jonnykang/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/jonnykang/gsutil:/Users/jonnykang/.rvm/bin:/tools:/platform-tools
export ANDROID_HOME=~/Library/Android/sdk
export PATH=/Users/jonnykang/.rvm/gems/ruby-2.4.1/bin:/Users/jonnykang/.rvm/gems/ruby-2.4.1@global/bin:/Users/jonnykang/.rvm/rubies/ruby-2.4.1/bin:/Users/jonnykang/.nvm/versions/node/v8.9.1/bin:/Users/jonnykang/.rbenv/bin:/Users/jonnykang/.rbenv/shims:/usr/local/bin:/Users/jonnykang/bin:/usr/local/heroku/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin:/usr/local/bin:/Users/jonnykang/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/jonnykang/gsutil:/Users/jonnykang/.rvm/bin:/tools:/platform-tools


export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
# Adding lines for internal arcanist.
export PATH=$PATH:/Users/jonnykang/apps/nfl-phabricator/arcanist/bin
# Uncomment the line below for bash completion.
#source /Users/jonnykang/apps/nfl-phabricator/arcanist/resources/shell/bash-completion
