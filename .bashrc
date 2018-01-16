export PATH=$HOME/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"
export PATH=$PATH
export EDITOR=/usr/local/bin/vim

# show me the path using path
function path(){
    old=$IFS
    IFS=:
    printf "%s\\n" $PATH
    IFS=$old
}

source ~/git-completion.bash

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

#z script!!!!!!!!!!!!
. ~/dev/z/z.sh

export NVM_DIR="/Users/jonny/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#colorful manuals!
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

alias d='date "+%Y-%m-%dT%H:%M:%S"'

export PATH=~/bin:$PATH

#aws tab completion
complete -C '~/.local/lib/aws/bin/aws_completer' aws

alias myip='curl https://wtfismyip.com/json | jq'

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
