#! /bin/bash

# Check for Homebrew, install if we don't have it
if test ! "$(command -v brew)"; then
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

function install_zlua {
  FILE=$HOME/z.lua
  if [ -f "$FILE" ]
  then
    echo "$FILE downloaded."
  else
    cd "$HOME" &&
      curl -O https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua &&
      printf "\\n installed z.lua script"
  fi
}

function install_git {
  brew install git
}

function install_hub {
  brew install hub
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

function install_fzf {
  brew install fzf
}

function install_lua {
  brew install lua
}

function install_exa {
  brew install exa
}

function install_python {
  brew install python
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
command -v hub >/dev/null 2>&1 || { echo >&2 "hub missing. Installing.."; install_hub;}
command -v fzf >/dev/null 2>&1 || { echo >&2 "fzf missing. Installing.."; install_fzf;}
command -v lua >/dev/null 2>&1 || { echo >&2 "lua missing. Installing.."; install_lua;}
command -v exa >/dev/null 2>&1 || { echo >&2 "exa is missing. downloading.."; install_exa; }
command -v python >/dev/null 2>&1 || { echo >&2 "python is missing. downloading.."; install_python; }

install_zlua;
install_completions;

brew install brew-cask-completion
# brew cask applications
[ -d "/Applications/Alfred 4.app" ] && echo "Alfred exists." || brew cask install alfred
[ -d "/Applications/Android Studio.app" ] && echo "Android Studio exists." || brew cask install android-studio
 # brew cask install beamer
 # brew cask install caffeine
 # brew cask install coconutbattery
 # brew cask install flux
 # brew cask install google-chrome
 # brew cask install gterm2
[ -d "/Applications/dTerm.app" ] && echo "sterm exists." || brew cask install iterm2
 # brew cask install openvpn
[ -d "/Applications/Postman.app" ] && echo "Postman exists." || brew cask install postman
 # brew cask install react-native-debugger
 # brew cask install slate
 # brew cask install slack
[ -d "/Applications/Spotify.app" ] && echo "Spotify exists." || brew cask install spotify
 # brew cask install visual-studio-code
 # brew cask install zoomus
 # brew cask install zeplin

# link bashrc && bash_profile
# =============================
function link_dotfiles {
  printf '\n\n Attempting to symlink files in /dev/dotfiles/* ...';
  printf "\\n ♻️ ♻️ ♻️ \\n";
  cd "$HOME" && cd "$(pwd)/dev/dotfiles" || return;
  ln -sfv "$(pwd)/.bash_profile" "$HOME/.bash_profile";
  ln -sfv "$(pwd)/.bashrc" "$HOME/.bashrc";
  ln -sfv "$(pwd)/.vimrc" "$HOME/.vimrc";

  FILE=$HOME/.config/nvim/init.vim
  if [ -f "$FILE" ]
  then
    echo "$FILE exist"
  else
    mkdir $HOME/.config/nvim/;
    echo "$FILE does not exist, created dir";
    ln -sfv "$(pwd)/init.vim" "$HOME/.config/nvim/init.vim";
  fi

  printf " done symlinking...";
  printf " ..................";
  printf "\\n ♻️ ♻️ ♻️ \\n\\n";
}

link_dotfiles;

# Load up new bash profile
# shellcheck source=/dev/null
. $HOME/.bash_profile;

#update system & homebrew
update;

test_imgcat;

figlet -f starwars -c Setup successful!
