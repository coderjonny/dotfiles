export PATH=$HOME/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"
export PATH=$PATH
export EDITOR=/usr/local/Cellar/vim/7.4.1795

# show me the path using path
function path(){
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

source ~/.git-completion.bash

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

#z script!!!!!!!!!!!! 
. ~/z/z.sh

export NVM_DIR="/Users/jonny/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
