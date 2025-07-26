#!/usr/bin/env bash
echo "$BASH_VERSION"

# ============================================================================
# HOMEBREW INSTALLATION
# ============================================================================

# Check for Homebrew, install if we don't have it
if test ! "$(command -v brew)"; then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# ============================================================================
# BREW PACKAGE INSTALLERS
# ============================================================================

function install_shellcheck { brew install shellcheck; }
function install_nvim { brew install neovim; }
function install_bat { brew install bat; }
function install_git { brew install git; }
function install_hub { brew install hub; }
function install_completions { printf "\\n install brew bash completions\\n"; brew install bash-completion@2; }
function install_tree { brew install tree; }
function install_jq { brew install jq; }
function install_ripgrep { brew install ripgrep; }
function install_imgcat { brew tap eddieantonio/eddieantonio; brew install imgcat; }
function install_figlet { brew install figlet; }
function install_lua { brew install lua; }
function install_exa { brew install eza; }
function install_python { brew install python; }
function install_m_cli { brew install m-cli; }
function install_mise { brew install mise; }

# Git delta with configuration
function install_delta { 
  brew install git-delta
  
  # Configure delta for git
  git config --global core.pager delta
  git config --global interactive.diffFilter delta --color-only
  git config --global delta.navigate true
  git config --global delta.light false
  git config --global delta.side-by-side true
  git config --global delta.line-numbers true
}

# FZF with key bindings and completion
function install_fzf { 
  brew install fzf; 
  # Install useful key bindings and fuzzy completion:
  $(brew --prefix)/opt/fzf/install --all;
}

# ============================================================================
# TEST FUNCTIONS
# ============================================================================

function test_imgcat { imgcat nyan-cat.png; }
function test_figlet { figlet -f starwars "Test Complete!"; }

# ============================================================================
# SHELL AND COMPLETION SETUP
# ============================================================================

# Modern bash installation and configuration
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

# Download z.lua for directory jumping
function install_zlua {
  local zlua_file=$HOME/z.lua
  if [ -f "$zlua_file" ]; then
    echo "$zlua_file downloaded."
  else
    cd "$HOME" &&
      curl -O https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua &&
      printf "\\n installed z.lua script"
  fi
}

# Download git completion script
function install_git_completion {
  local git_completion_file=$HOME/.git-completion.bash
  if [ -f "$git_completion_file" ]; then
    echo "$git_completion_file already downloaded."
  else
    cd "$HOME" &&
      curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
      printf "\\n installed git-completion script"
  fi
}

# ============================================================================
# TOOL INSTALLATION (DRY Helper)
# ============================================================================

# Helper function to check and install tools (eliminates repetition)
check_and_install() {
  local cmd="$1"
  local message="$2"
  local installer="$3"
  local tester="${4:-}"
  
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo >&2 "$message"
    "$installer"
    [ -n "$tester" ] && "$tester"
  fi
}

# Install all CLI tools
check_and_install "shellcheck" "Shellcheck missing. Installing.." "install_shellcheck"
check_and_install "nvim" "Neovim missing. Installing.." "install_nvim"
check_and_install "bat" "Bat's missing. Installing.. 🦇 🦇 🦇" "install_bat"
check_and_install "git" "Git missing. Installing.." "install_git"
check_and_install "tree" "tree missing. Installing.." "install_tree"
check_and_install "jq" "jq missing. Installing.." "install_jq"
check_and_install "imgcat" "imgcat missing. Installing.." "install_imgcat" "test_imgcat"
check_and_install "figlet" "figlet missing. Installing.." "install_figlet" "test_figlet"
check_and_install "hub" "hub missing. Installing.." "install_hub"
check_and_install "fzf" "fzf missing. Installing.." "install_fzf"
check_and_install "lua" "lua missing. Installing.." "install_lua"
check_and_install "eza" "eza is missing. downloading.." "install_exa"
check_and_install "python3" "python3 is missing. downloading.." "install_python"
check_and_install "m" "m_cli is missing. downloading.." "install_m_cli"
check_and_install "mise" "mise is missing. downloading.." "install_mise"
check_and_install "delta" "delta is missing. downloading.." "install_delta"
check_and_install "rg" "ripgrep is missing. downloading.." "install_ripgrep"

# ============================================================================
# SYSTEM CONFIGURATION
# ============================================================================

upgrade_bash;

# Note: If using iTerm2, you may also want to configure it to use the new bash:
# iTerm2 → Preferences → Profiles → General → Command → Custom Shell: /opt/homebrew/bin/bash

install_zlua;
install_git_completion;
install_completions;
# Note: brew-cask-completion is included in bash-completion@2

# ============================================================================
# APPLICATIONS
# ============================================================================

# brew cask applications
[ -d "/Applications/Alfred 4.app" ] && echo "Alfred exists." || brew install --cask alfred
[ -d "/Applications/anki.app" ] && echo "anki exists." || brew install --cask anki
[ -d "/Applications/iTerm.app" ] && echo "iterm exists." || brew install --cask iterm2
[ -d "/Applications/hammerspoon.app" ] && echo "hammerspoon exists." || brew install --cask hammerspoon

# ============================================================================
# DOTFILES LINKING
# ============================================================================

# Link dotfiles to home directory
function link_dotfiles {
  printf '\n\n Attempting to symlink files in /dev/dotfiles/* ...';
  printf "\\n ♻️ ♻️ ♻️ \\n";
  cd "$HOME" && cd "$(pwd)/dev/dotfiles" || return;
  ln -sfv "$(pwd)/.bash_profile" "$HOME/.bash_profile";
  ln -sfv "$(pwd)/.bashrc" "$HOME/.bashrc";
  ln -sfv "$(pwd)/.vimrc" "$HOME/.vimrc";

  local nvim_config_file=$HOME/.config/nvim/init.vim
  if [ -f "$nvim_config_file" ]; then
    echo "$nvim_config_file exist"
  else
    mkdir $HOME/.config/nvim/;
    echo "$nvim_config_file does not exist, created dir";
    ln -sfv "$(pwd)/init.vim" "$HOME/.config/nvim/init.vim";
  fi

  local hammerspoon_config_file=$HOME/.hammerspoon/init.lua
  if [ -f "$hammerspoon_config_file" ]; then
    echo "$hammerspoon_config_file exist, symlinking"
    ln -sfv "$(pwd)/init.lua" "$HOME/.hammerspoon/init.lua";
  fi

  printf " done symlinking...";
  printf " ..................";
  printf "\\n ♻️ ♻️ ♻️ \\n\\n";
}

link_dotfiles;

# ============================================================================
# FINALIZATION
# ============================================================================

# print nyancat
test_imgcat;

# print success
figlet -c -w 100 -S -f poison "SETUP"
figlet -c -w 100 -S -f poison "SUCCESSFUL!"
