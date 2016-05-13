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
#emojis=(<U+1F436> <U+1F43A> <U+1F431> <U+1F42D> <U+1F439> <U+1F430> <U+1F438> <U+1F42F> <U+1F428> <U+1F43B> <U+1F437> <U+1F42E> <U+1F435> <U+1F43C> <U+1F427> <U+1F40D> <U+1F422> <U+1F419> <U+1F420> <U+1F433> <U+1F42C> <U+1F425>)
#emoji=🐻
emoji2=🐼
emoji3=🐨
#emojis=( 🐻 🐼 🐨 )
#emojis=($emoji $emoji2 $emoji3)
#emoji_rand='`echo ${emojis[$RANDOM % 22]}`'

gitbranch="\$(parse_git_branch)$emoji2 -> \[\033[0m\]"
#emojis=(🐶 🐺 🐱 🐭 🐹 🐰 🐸 🐯 🐨 🐻 🐷 🐮 🐵 🐼 🐧 🐍 🐢 🐙 🐠 🐳 🐬 🐥)
#emoji=' `echo ${emojis[$RANDOM % 22]}`'}
#export PS1="\[\033[0;36m\]\T | \W$git_branch | $emoji  > \[\e[0m\]"

PS1=$face$path$gitbranch

#daniel's PS1
#PS2="\[\e[32m\]\$(parse_git_branch)\[\e[34m\]\h:\W \$ \[\e[m\]"
#export PS2


# Commands
alias startmongo='mongod run --config /usr/local/Cellar/mongodb/1.6.2-x86_64/mongod.conf'
alias startpostgres='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppostgres='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias startmysql='mysql.server start'
alias stopmysql='mysql.server stop'
alias startredis='redis-server /usr/local/etc/redis.conf'
alias app='bundle exec'
alias color='git config color.ui true'

# git stuff
alias gs='git status '
alias ga='git add '
alias gb='git branch -v'
alias gc='git commit -m'
alias gd='git diff'
alias go='git checkout '
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

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}

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
