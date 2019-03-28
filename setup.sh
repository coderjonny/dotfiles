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

function install_imgcat {
    brew tap eddieantonio/eddieantonio
    brew install imgcat
}

function test_imgcat {
    imgcat nyan-cat.png
}

function install_figlet {
    brew install figlet
}

# check packages ..
command -v shellcheck >/dev/null 2>&1 || { echo >&2 "Shellcheck missing. Installing.."; install_shellcheck;}
command -v nvim >/dev/null 2>&1 || { echo >&2 "Neovim missing. Installing.."; install_nvim;}
command -v ccat >/dev/null 2>&1 || { echo >&2 "Pretty ccat colors are missing. Installing..🎨"; install_ccat;}
command -v git --version >/dev/null 2>&1 || { echo >&2 "Git missing. Installing.."; install_git;}
command -v diff-so-fancy >/dev/null 2>&1 || { echo >&2 "diff-so-fancy missing. Installing.."; install_diff-so-fancy;}
command -v tree >/dev/null 2>&1 || { echo >&2 "tree missing. Installing.."; install_tree;}
command -v jq >/dev/null 2>&1 || { echo >&2 "jq missing. Installing.."; install_jq;}
command -v imgcat >/dev/null 2>&1 || { echo >&2 "imgcat missing. Installing.."; install_imgcat; test_imgcat;}
command -v figlet >/dev/null 2>&1 || { echo >&2 "figlet missing. Installing.."; install_figlet; test_figlet;}
install_completions;

# link bashrc && bash_profile
# =============================
function link_dotfiles {
  printf '\n\n Attempting to symlink files in /dev/dotfiles/* ...';
  printf "\\n ♻️ ♻️ ♻️ \\n";
  cd "$HOME" && cd "$(pwd)/dev/dotfiles" || return;
  ln -sfv "$(pwd)/.bash_profile" "$HOME/.bash_profile";
  ln -sfv "$(pwd)/.bashrc" "$HOME/.bashrc";
  ln -sfv "$(pwd)/.vimrc.before" "$HOME/.vimrc.before";
  ln -sfv "$(pwd)/.vimrc.after" "$HOME/.vimrc.after";
  ln -sfv "$(pwd)/init.vim" "$HOME/.config/nvim/init.vim";

  # shellcheck source=/dev/null
  . $HOME/.bash_profile;

  unalias z 2>/dev/null || { echo >&2 "z script is missing. downloading.."; install_zscript;}

  printf "\\n done symlinking...\\n";
}
link_dotfiles;

#update system & homebrew
update;

test_imgcat;



figlet -f starwars -c Setup successful!
