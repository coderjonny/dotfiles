#!/usr/bin/env bash
echo "$BASH_VERSION"

# Check for Homebrew, install if we don't have it
if test ! "$(command -v brew)"; then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

function install_shellcheck { brew install shellcheck; }
function install_nvim { brew install neovim; }
function install_bat { brew install bat; }
function install_git { brew install git; }
function install_hub { brew install hub; }
function install_completions { printf "\\n install brew bash completions\\n"; brew install bash-completion@2; }
function install_tree { brew install tree; }
function install_jq { brew install jq; }
function install_imgcat { brew tap eddieantonio/eddieantonio; brew install imgcat; }
function test_imgcat { imgcat nyan-cat.png; }
function install_figlet { brew install figlet; }
function install_fzf { 
  brew install fzf; 
  # Install useful key bindings and fuzzy completion:
  $(brew --prefix)/opt/fzf/install --all;
}
function install_lua { brew install lua; }
function install_exa { brew install eza; }
function install_python { brew install python; }
function install_m_cli { brew install m-cli; }
function install_mise { brew install mise; }

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

function upgrade_bash {
  echo "🐚 Checking bash versions..."
  
  # Show current system bash version
  echo "System bash: $(/bin/bash --version | head -1)"
  
  # Install modern bash via Homebrew
  if [ ! -f "/opt/homebrew/bin/bash" ]; then
    echo "📦 Installing modern bash via Homebrew..."
    brew install bash
  else
    echo "✅ Modern bash already installed"
  fi
  
  # Show Homebrew bash version
  if [ -f "/opt/homebrew/bin/bash" ]; then
    echo "Homebrew bash: $(/opt/homebrew/bin/bash --version | head -1)"
    
    # Add Homebrew bash to allowed shells if not already there
    if ! grep -q "/opt/homebrew/bin/bash" /etc/shells; then
      echo "🔐 Adding Homebrew bash to /etc/shells (requires sudo)..."
      echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells
    fi
    
    # Change default shell to Homebrew bash
    echo "🔄 Changing default shell to modern bash..."
    if sudo chsh -s /opt/homebrew/bin/bash "$USER"; then
      echo "✅ Default shell changed successfully"
      echo "🎉 You'll need to restart Terminal/iTerm2 for the change to take effect"
    else
      echo "❌ Failed to change default shell"
    fi
  else
    echo "❌ Failed to install modern bash"
    return 1
  fi
}

function install_git_completion {
  FILE=$HOME/.git-completion.bash
  if [ -f "$FILE" ]
  then
    echo "$FILE already downloaded."
  else
    cd "$HOME" &&
      curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
      printf "\\n installed git-completion script"
  fi
}

# check packages ..
command -v shellcheck >/dev/null 2>&1 || { echo >&2 "Shellcheck missing. Installing.."; install_shellcheck;}
command -v nvim >/dev/null 2>&1 || { echo >&2 "Neovim missing. Installing.."; install_nvim;}
command -v bat >/dev/null 2>&1 || { echo >&2 "Bat's missing. Installing.. 🦇 🦇 🦇"; install_bat;}
command -v git --version >/dev/null 2>&1 || { echo >&2 "Git missing. Installing.."; install_git;}
command -v diff-so-fancy >/dev/null 2>&1 || { echo >&2 "diff-so-fancy missing. Installing.."; install_diff-so-fancy;}
command -v tree >/dev/null 2>&1 || { echo >&2 "tree missing. Installing.."; install_tree;}
command -v jq >/dev/null 2>&1 || { echo >&2 "jq missing. Installing.."; install_jq;}
command -v imgcat >/dev/null 2>&1 || { echo >&2 "imgcat missing. Installing.."; install_imgcat; test_imgcat;}
command -v figlet >/dev/null 2>&1 || { echo >&2 "figlet missing. Installing.."; install_figlet; test_figlet;}
command -v hub >/dev/null 2>&1 || { echo >&2 "hub missing. Installing.."; install_hub;}
command -v fzf >/dev/null 2>&1 || { echo >&2 "fzf missing. Installing.."; install_fzf;}
command -v lua >/dev/null 2>&1 || { echo >&2 "lua missing. Installing.."; install_lua;}
command -v eza >/dev/null 2>&1 || { echo >&2 "eza is missing. downloading.."; install_exa; }
command -v python3 >/dev/null 2>&1 || { echo >&2 "python3 is missing. downloading.."; install_python; }
command -v m >/dev/null 2>&1 || { echo >&2 "m_cli is missing. downloading.."; install_m_cli; }
command -v m >/dev/null 2>&1 || { echo >&2 "mise is missing. downloading.."; install_mise; }

upgrade_bash;

# Note: If using iTerm2, you may also want to configure it to use the new bash:
# iTerm2 → Preferences → Profiles → General → Command → Custom Shell: /opt/homebrew/bin/bash

install_zlua;
install_git_completion;
install_completions;
# Note: brew-cask-completion is included in bash-completion@2

# brew cask applications
# [ -d "/Applications/Alfred 4.app" ] && echo "Alfred exists." || brew install --cask alfred
# [ -d "/Applications/anki.app" ] && echo "anki exists." || brew install --cask anki
# [ -d "/Applications/Android Studio.app" ] && echo "Android Studio exists." || brew install --cask android-studio
# [ -d "/Applications/iTerm.app" ] && echo "iterm exists." || brew install --cask iterm2
# [ -d "/Applications/Slack.app" ] && echo "Slack exists." || brew install --cask slack
# [ -d "/Applications/Slate.app" ] && echo "Slate exists." || brew install --cask slate
# [ -d "/Applications/React\ Native\ Debugger.app" ] && echo "React Native Debugger exists." || brew install --cask react-native-debugger
 # brew cask install beamer
 # brew cask install caffeine
 # brew cask install coconutbattery
 # brew cask install flux
 # brew cask install google-chrome
 # brew cask install gterm2
 # brew cask install openvpn
 # [ -d "/Applications/Postman.app" ] && echo "Postman exists." || brew install postman
 # brew cask install react-native-debugger
 # brew cask install slate
 # brew cask install zoomus
 # brew cask install visual-studio-code
 # brew cask install zeplin
brew install hammerspoon --cask

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

  FILE=$HOME/.hammerspoon/init.lua
  if [ -f "$FILE" ]
  then
    echo "$FILE exist, symlinking"
    ln -sfv "$(pwd)/init.lua" "$HOME/.hammerspoon/init.lua";
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

# print nyancat
test_imgcat;

# print success
figlet -f starwars -c Setup successful!
