# 🌟 Jonny's dotfiles

> A comprehensive, modern macOS development environment featuring intelligent bash enhancements, fuzzy search, and productivity-focused tooling.

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
- **Modern CLI Tools**: `eza`, `bat`, `tree`, `fzf`, `z.lua` for enhanced productivity
- **Git Integration**: Beautiful diffs with `diff-so-fancy` and streamlined workflows
- **Terminal Enhancement**: Syntax highlighting, smart directory navigation
- **iTerm2 Optimization**: Custom profiles and color schemes

## 🚀 Quick Start

### Prerequisites
- macOS (tested on latest versions)
- Terminal.app or iTerm2
- Internet connection for downloading dependencies

### Installation

**⚡ One-line install:**
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./setup.sh
```

**📋 Step-by-step:**
```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Navigate to dotfiles directory
cd ~/dotfiles

# Run the setup script
./setup.sh
```

## 📚 What's Included

### 🔧 Core Configuration Files
- **`.bash_profile`**: Comprehensive terminal environment with 56 productivity tips
- **`.bashrc`**: Shell configuration and aliases  
- **`.vimrc`**: Neovim configuration
- **`init.vim`**: Modern Neovim setup with Vim-Plug
- **`git-completion.bash`**: Enhanced Git autocomplete

### 🛠️ Command Line Tools
The setup script automatically installs and configures:

**Essential Development Tools:**
- `neovim` - Modern Vim-based editor
- `fzf` - Fuzzy finder for files, history, and more
- `eza` - Modern `ls` replacement with icons
- `bat` - Syntax-highlighted `cat` replacement
- `tree` - Directory structure visualization
- `z.lua` - Smart directory jumping
- `diff-so-fancy` - Beautiful git diffs

**Productivity & Utilities:**
- `shellcheck` - Shell script analysis
- `jq` - JSON processor
- `figlet` - ASCII art text
- `imgcat` - Display images in terminal
- `hub` - GitHub CLI integration

### 📱 macOS Applications
Automatically installs via Homebrew Cask:
- **Development**: Visual Studio Code, Android Studio, Postman
- **Communication**: Slack, Zoom
- **Productivity**: Alfred, Caffeine, Flux
- **Entertainment**: Spotify
- **Utilities**: iTerm2, Beamer, CoconutBattery

### 🎨 Terminal Themes
- **Seoul256**: Beautiful iTerm2 color scheme (light & dark variants)
- **Custom iTerm Profile**: Optimized settings for development workflow

## ⚡ Key Features in Detail

### Intelligent Command Discovery
```bash
# Find commands with fuzzy search
query git                    # Search for git-related commands
which_enhanced node          # Enhanced which with location details
show_all_commands           # Browse all available commands
```

### Enhanced Autocomplete
- **Smart tab completion** for commands, files, and directories
- **Context-aware suggestions** based on command type
- **Fuzzy matching** for partial inputs

### Productivity Tips System
Get random productivity tips with every new terminal session:
```bash
Random productivity tip: Use 'cmd+shift+.' to show hidden files in Finder
```

### Optimized Aliases
```bash
e filename.txt              # Open in neovim
s                          # Open localhost in browser  
h                          # Show help/man page
ll                         # Enhanced listing with eza
..                         # Go up one directory
```

## 🔄 Updating

To update your dotfiles to the latest version:
```bash
cd ~/dotfiles
git pull origin main
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
