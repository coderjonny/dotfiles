#!/usr/bin/env bash

# start=`date +%s`

echo "Bash: $BASH_VERSION"
printf "\n"
# echo "Battery status: $(m battery status)"
# printf "\n"

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

# heroku autocomplete setup
# HEROKU_AC_BASH_SETUP_PATH=/Users/jonny/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# macOS Catalina is configured to use a different shell warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

# end=`date +%s`
# runtime=$((end-start))
# printf "Execution time: %s seconds\n" "$runtime"


export ANDROID_HOME="/Users/`whoami`/Library/Android/sdk"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin