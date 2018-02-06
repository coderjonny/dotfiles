#!/bin/bash

brew uninstall neovim
brew uninstall ccat
# brew uninstall shellcheck
brew uninstall diff-so-fancy

NVIM=~/.config/nvim/
if [ -d $NVIM ]; then
    rm -rf $NVIM
    echo "removed $NVIM"
fi
