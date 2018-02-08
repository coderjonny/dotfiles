#! /bin/bash

# Check for Homebrew, install if we don't have it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

function install_shellcheck {
    brew install shellcheck
}

function install_nvim {
    brew install neovim
}

function install_ccat {
    brew install ccat
}

function install_zscript {
  cd "$HOME" && curl -O https://raw.githubusercontent.com/rupa/z/master/z.sh
}

function install_git {
  brew install git
}
function install_diff-so-fancy {
  brew install diff-so-fancy
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  git config --global color.ui true
  git config --global color.diff-highlight.oldNormal    "red bold"
  git config --global color.diff-highlight.oldHighlight "red bold 52"
  git config --global color.diff-highlight.newNormal    "green bold"
  git config --global color.diff-highlight.newHighlight "green bold 22"

  git config --global color.diff.meta       "yellow"
  git config --global color.diff.frag       "magenta bold"
  git config --global color.diff.commit     "yellow bold"
  git config --global color.diff.old        "red bold"
  git config --global color.diff.new        "green bold"
  git config --global color.diff.whitespace "red reverse"
}

function install_completions {
  brew install bash-completion
}

function install_tree {
    brew install tree
}

function install_jq {
    brew install jq
}

# check packages ..
command -v shellcheck >/dev/null 2>&1 || { echo >&2 "Shellcheck missing. Installing.."; install_shellcheck;}
command -v nvim >/dev/null 2>&1 || { echo >&2 "Neovim missing. Installing.."; install_nvim;}
command -v ccat >/dev/null 2>&1 || { echo >&2 "Pretty ccat colors are missing. Installing..🎨"; install_ccat;}
unalias z 2>/dev/null || { echo >&2 "z script is missing. downloading.."; install_zscript;}
command -v git --version >/dev/null 2>&1 || { echo >&2 "Git missing. Installing.."; install_git;}
command -v diff-so-fancy >/dev/null 2>&1 || { echo >&2 "diff-so-fancy missing. Installing.."; install_diff-so-fancy;}
command -v tree >/dev/null 2>&1 || { echo >&2 "tree missing. Installing.."; install_tree;}
command -v jq >/dev/null 2>&1 || { echo >&2 "jq missing. Installing.."; install_jq;}
install_completions;

# link bashrc && bash_profile
function link_dotfiles {
  echo 'attempting to symlink files in /dev/dotfiles/* ...';
  cd "$HOME" && cd "$(pwd)/dev/dotfiles" || return;
  ln -sfv "$(pwd)/.bash_profile" "$HOME/.bash_profile";
  ln -sfv "$(pwd)/.bashrc" "$HOME/.bashrc";
  # shellcheck source=/dev/null
  . $HOME/.bash_profile;
  printf "\\n done symlinking...";
}
link_dotfiles;

#  __   _ _______  _____  _    _ _____ _______
#  | \  | |______ |     |  \  /    |   |  |  |
#  |  \_| |______ |_____|   \/   __|__ |  |  |
#
#  _______ _______ _______ _     _  _____
#  |______ |______    |    |     | |_____]
#  ______| |______    |    |_____| |
###############################################
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
        printf "Created neo init file..  -> %s\\n" "$INIT"
        ccat $INIT
    else
        echo "init file already exists.. you're good to go!"
fi
# echo "Do you wanna check it nvim? (1 or 2)"
# select yn in "yes" "no"; do
#     case $yn in
#         yes ) nvim .; break;;
#         no ) break;;
#     esac
# done
