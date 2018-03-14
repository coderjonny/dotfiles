#! /bin/bash

export EDITOR=/usr/local/bin/nvim

# show me the paths
function paths(){
  tr ':' '\n' <<< "$PATH"
}


# load up the completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
