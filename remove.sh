#!/bin/bash

brew uninstall neovim
brew uninstall ccat

NVIM=~/.config/nvim/
if [ -d $NVIM ]; then
    rm -rf $NVIM
    echo "removed $NVIM"
fi
