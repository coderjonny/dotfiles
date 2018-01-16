# .bash_profile

# source .bashrc if exists
# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

#show happy face
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

#time_prompt='\D{%F %T}\n\$ '
#now=$(date +"%I:%M%p")" "

FACE="\`if [ \$? = 0 ]; then
        echo \\[\\e[33m\\]^_^\\[\\e[0m\\];
    else
        echo \\[\\e[31m\\]O_O\\[\\e[0m\\];
    fi\` "

CURRENT_PATH="\\[\\033[32m\\]\\w \\[\\033[0m\\]"

emojis=(🐶 🐺 🐱 🐭 🐹 🐰 🐸 🐯 🐨 🐻 🐷 🐮 🐵 🐼 🐧 🐍 🐢 🐙 🐠 🐳 🐬 🐥)
emoji_rand=${emojis[$RANDOM % 22]}

GITBRANCH="\$(parse_git_branch)"
EMOJI="$emoji_rand -> \\[\\033[0m\\]"

PS1=$FACE$CURRENT_PATH$GITBRANCH$EMOJI

# Commands
alias startpostgres='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppostgres='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias startredis='redis-server /usr/local/etc/redis.conf'

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

#other commands
function path(){
    old=$IFS
    IFS=:
    printf "%s\\n" "$PATH"
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

    cd "$(printf "%s" "${DIRS[@]}")" || return
}

#rbenv stuff
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH="$HOME/.rbenv/bin:$PATH"

export PATH=${PATH}:$HOME/gsutil

# file navigation
alias l='ls -logGFh'
alias la='ls -logGFrah'
alias c='ccat'
alias ..='cd ..'
alias mkdir='mkdir -pv'
alias rm='rm -v'

export NVM_DIR="$HOME/.nvm"

# shellcheck source=$HOME/.nvm/nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

alias update='
    sudo softwareupdate -i -a;
    brew update;
    brew upgrade;
    brew cleanup;
    # npm install npm -g;
    # npm update -g;
'

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

export ANDROID_HOME=~/Library/Android/sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
# Adding lines for internal arcanist.
export PATH=$PATH:/Users/jonny/apps/nfl-phabricator/arcanist/bin
# Uncomment the line below for bash completion.
source /Users/jonny/apps/nfl-phabricator/arcanist/resources/shell/bash-completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*
