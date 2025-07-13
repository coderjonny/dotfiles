#!/usr/bin/env bash

# Silence the deprecation warning on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# Set environment variables
ANDROID_HOME_SDK="/Users/$(whoami)/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_HOME_SDK"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

# Function to add a directory to the PATH if it exists and is not already there
add_to_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

# Add Android tools to PATH
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/tools/bin"

export PATH

echo "Bash: $BASH_VERSION"
printf "\n"

# Custom functions
# ----------------

# show me the paths
function paths(){
  tr ':' '\n' <<< "$PATH"
}

# Aliases
# -------
alias git=hub

# Completions and other setups
# ----------------------------

# Heroku autocomplete setup
# HEROKU_AC_BASH_SETUP_PATH=/Users/jonny/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

# NVM setup
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
