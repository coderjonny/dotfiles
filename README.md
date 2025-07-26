# 🌟 Jonny's dotfiles

> A comprehensive, modern macOS development environment featuring intelligent bash enhancements, automated tool installation, and productivity-focused configuration.

<div align="center">

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/bash-5.0+-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](#)
[![Neovim](https://img.shields.io/badge/neovim-57A143?style=flat-square&logo=neovim&logoColor=white)](#)
[![iTerm2](https://img.shields.io/badge/iTerm2-000000?style=flat-square&logo=iterm2&logoColor=white)](#)

</div>

<img width="769" height="964" alt="image" src="https://github.com/user-attachments/assets/36ede996-d9e6-444e-a4f2-ef2df00518ac" />

## ✨ Features

### 🎯 Intelligent Terminal Environment

- **Smart Command Discovery**: Enhanced `query()` and `which_enhanced()` functions with fuzzy search
- **Comprehensive Autocomplete**: Advanced bash completion with `fzf` integration
- **Productivity Tips**: 56 rotating tips to improve workflow efficiency
- **Optimized Aliases**: Streamlined shortcuts (`e` for nvim, `s` for localhost, `h` for help)

### 🔍 Fuzzy Search Integration

- **File Navigation**: `Ctrl+T` for fuzzy file selection
- **Command History**: `Ctrl+R` for intelligent history search
- **Directory Jumping**: `Alt+C` for quick directory changes
- **Smart Completion**: Context-aware autocomplete for commands and paths

### 🛠️ Development Tools

- **Modern CLI Tools**: `eza`, `bat`, `tree`, `fzf`, `ripgrep` for enhanced productivity
- **Git Integration**: Beautiful diffs with `git-delta` and streamlined workflows
- **Terminal Enhancement**: Syntax highlighting, smart directory navigation
- **iTerm2 Optimization**: Custom profiles and color schemes

### 🚀 Automated Setup

- **Intelligent Installation**: DRY helper functions eliminate code repetition
- **Idempotent Operations**: Safe to run multiple times without conflicts
- **Clear Organization**: Sectioned setup with professional structure
- **Error Handling**: Robust installation with helpful feedback

## 🚀 Quick Start

### Prerequisites

- macOS (tested on latest versions)
- Terminal.app or iTerm2
- Internet connection for downloading dependencies

### Installation

**⚡ One-line install:**

```bash
git clone https://github.com/coderjonny/dotfiles.git ~/dev/dotfiles && cd ~/dev/dotfiles && ./setup.sh
```

**📋 Step-by-step:**

```bash
# Clone the repository
git clone https://github.com/coderjonny/dotfiles.git ~/dev/dotfiles

# Navigate to dotfiles directory
cd ~/dev/dotfiles

# Run the setup script
./setup.sh
```

## 📚 What's Included

### 🔧 Core Configuration Files

- **`.bash_profile`**: Comprehensive terminal environment with 56 productivity tips
- **`.bashrc`**: Shell configuration and aliases
- **`.vimrc`**: Neovim configuration
- **`init.vim`**: Modern Neovim setup with Vim-Plug
- **`init.lua`**: Hammerspoon automation configuration

### 🛠️ Command Line Tools

The setup script automatically installs and configures:

**Essential Development Tools:**
- `neovim` - Modern Vim-based editor
- `git` - Version control system
- `git-delta` - Beautiful git diffs with syntax highlighting
- `fzf` - Fuzzy finder for files, history, and more
- `hub` - GitHub CLI integration
- `shellcheck` - Shell script analysis

**Productivity & File Management:**
- `eza` - Modern `ls` replacement with icons
- `bat` - Syntax-highlighted `cat` replacement  
- `tree` - Directory structure visualization
- `ripgrep` - Ultra-fast text search tool
- `jq` - JSON processor and formatter

**Terminal Enhancement:**
- `bash-completion@2` - Advanced bash autocompletion
- `figlet` - ASCII art text generation
- `imgcat` - Display images in terminal (iTerm2)
- `lua` - Lightweight scripting language
- `z.lua` - Smart directory jumping script

**Development Environment:**
- `python3` - Python programming language
- `m-cli` - macOS command line tools
- `mise` - Runtime version manager

### 📱 macOS Applications

Automatically installs via Homebrew Cask:

- **Alfred 4** - Powerful productivity app and launcher
- **Anki** - Spaced repetition flashcard software  
- **iTerm2** - Advanced terminal emulator
- **Hammerspoon** - macOS automation and window management

### 🎨 Terminal Themes

- **Seoul256**: Beautiful iTerm2 color scheme (light & dark variants)
- **Custom iTerm Profile**: Optimized settings for development workflow

## ⚡ Setup Script Features

### 🏗️ Intelligent Architecture

The setup script follows modern DevOps practices:

```bash
# ============================================================================
# HOMEBREW INSTALLATION
# ============================================================================
# Checks for and installs Homebrew package manager

# ============================================================================  
# TOOL INSTALLATION (DRY Helper)
# ============================================================================
# Uses helper function to eliminate 90% code repetition
check_and_install "tool" "message" "installer" "optional_tester"
```

### 🔄 Idempotent Operations

- **Safe Re-runs**: Check before install, skip if already present
- **No Duplicates**: Won't reinstall existing tools
- **Clean Updates**: Easy to modify and extend

### 🎯 Key Functions

```bash
# Upgrade to modern bash (5.x from macOS default 3.x)
upgrade_bash

# Link configuration files to home directory  
link_dotfiles

# Install development tools with testing
check_and_install "figlet" "Installing figlet.." "install_figlet" "test_figlet"
```

## 🔄 Updating

To update your dotfiles to the latest version:

```bash
cd ~/dev/dotfiles
git pull origin master
./setup.sh
```

## 🎛️ Customization

### Adding Personal Configuration

Create a `.bash_local` file in your home directory for personal customizations:

```bash
# ~/.bash_local
export CUSTOM_VAR="your_value"
alias myalias="custom command"
```

### Modifying the Setup

The setup script is modular and can be customized:

- Edit `setup.sh` to add/remove tools
- Modify configuration files in the repository
- Add custom iTerm2 profiles in `iterm_perfs/`

## 🔧 Manual Configuration

### Git Setup

Configure Git with your details:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### iTerm2 Profile

Import the custom iTerm2 profile:

1. iTerm2 → Preferences → Profiles
2. Import profile from `iterm_perfs/iterm_profile.json`

### After Setup

After running the setup script:

```bash
# Manually source your new bash profile
source ~/.bash_profile

# Run system updates when convenient
update
```

## 🐛 Troubleshooting

### Common Issues

**Permission denied when running setup.sh:**
```bash
chmod +x setup.sh
./setup.sh
```

**Homebrew installation fails:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Bash completion not working:**
```bash
brew install bash-completion@2
# Restart terminal
```

**Slow prompt performance:**
The bash profile includes optimized git status caching for instant response times.

## 🏆 Recent Improvements

- **🏗️ Refactored Architecture**: Clean section organization with professional structure
- **🔄 DRY Principles**: 90% reduction in code repetition through helper functions  
- **🐛 Bug Fixes**: Fixed duplicate command checks and missing functions
- **📝 Better Documentation**: Clear function comments and improved variable naming
- **⚡ Performance**: Optimized git status checking with intelligent caching

## 🤝 Contributing

Feel free to suggest improvements or report issues:

1. Fork the repository
2. Create a feature branch  
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Inspired by the dotfiles community and these excellent repositories:

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- Various open-source productivity tools and configurations

---

<div align="center">
<strong>Happy coding! 🚀</strong>
</div>
