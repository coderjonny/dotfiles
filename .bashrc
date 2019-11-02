#! /bin/bash

# show me the paths
function paths(){
  tr ':' '\n' <<< "$PATH"
}

# load up the completions
# sed bug in macOs
# [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# heroku autocomplete setup
# HEROKU_AC_BASH_SETUP_PATH=/Users/jonny/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;
alias git=hub
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/Users/jonny/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
