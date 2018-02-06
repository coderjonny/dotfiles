#! /bin/bash

export EDITOR=/usr/local/bin/vim

# show me the paths
function paths(){
  tr ':' '\n' <<< "$PATH"
}

#z script!!!!!!!!!!!!
# shellcheck source=/dev/null
. ~/dev/z/z.sh

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
        nvm use
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}
cd() { builtin cd "$@"; 'load-nvmrc'; }

#aws tab completion
complete -C "$HOME/.local/lib/aws/bin/aws_completer" aws
