#!/bin/bash

function install_nvim {
    brew install neovim
}

function install_ccat {
    brew install ccat
}

if brew ls --versions neovim > /dev/null; then
    echo 'neovim already installed'
else
    echo "installing neovim";
    install_nvim;
fi

command -v ccat >/dev/null 2>&1 || { echo >&2 "Pretty ccat colors are missing. Installing..🎨"; install_ccat;}

NEO_DIR=~/.config/nvim/
INIT=~/.config/nvim/init.vim
CONTENTS=$( cat <<EOF
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vimrc
EOF
)

function insert_init_contents {
    echo "$CONTENTS" >> $INIT;
}

# if the init file doesn't exist then create it and add contents
if [ ! -f $INIT ]
    then
        mkdir $NEO_DIR;
        insert_init_contents;
        echo "Created neo init fil..  -> '$INIT' \n"
        ccat $INIT
    else
        echo "init file already exists.. you're good to go!"
fi

echo "Do you wanna check it out? (1 or 2)"
select yn in "yes" "no"; do
    case $yn in
        yes ) nvim .; break;;
        no ) break;;
    esac
done
