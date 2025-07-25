#!/usr/bin/env bash

# ==============================================================================
# JONNY'S BASH PROFILE
# ==============================================================================

# Source .bashrc if it exists
[ -r ~/.bashrc ] && . ~/.bashrc

# ==============================================================================
# ENVIRONMENT SETUP
# ==============================================================================

# Editor setup
export VISUAL=/opt/homebrew/bin/nvim
export EDITOR="$VISUAL"
export POSTGREST_HOST=35.203.146.107

# Add paths
# Note: .bashrc, which is sourced above, contains the add_to_path function
# and handles Android SDK paths.
add_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Initialize tools
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(lua ~/z.lua --init bash enhanced once fzf)"
if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi
export _ZL_ECHO=1

# Enhanced fzf key bindings and completion
if command -v fzf &> /dev/null; then
    # Ctrl+T - file/directory fuzzy search
    # Ctrl+R - command history fuzzy search  
    # Alt+C - cd into directory fuzzy search
    eval "$(fzf --bash)"
fi

# ==============================================================================
# PROMPT SETUP - CLEAN & READABLE
# ==============================================================================

# Color Palette (Auto-detecting Light/Dark Mode)
# ----------------------------------------------------------------------------
declare -r NO_COLOR="\[\033[0m\]"
declare -r BOLD="\[\033[1m\]"

# Function to detect if we're in dark mode and set colors accordingly
set_color_palette() {
    # Try to detect dark mode via macOS system preferences
    local is_dark_mode=false
    
    # Check if we can detect macOS dark mode
    if command -v defaults &> /dev/null; then
        local dark_mode_setting
        dark_mode_setting=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
        [[ "$dark_mode_setting" == "Dark" ]] && is_dark_mode=true
    fi
    
    # Alternative: Check iTerm2 background color if available
    if [[ "$is_dark_mode" == false ]] && [[ -n "$ITERM_SESSION_ID" ]]; then
        # This is a heuristic - in practice, you might need to configure iTerm2 
        # to set an environment variable based on the profile
        if [[ -n "$ITERM_PROFILE" ]] && [[ "$ITERM_PROFILE" =~ [Dd]ark ]]; then
            is_dark_mode=true
        fi
    fi
    
    if [[ "$is_dark_mode" == true ]]; then
        # Lighter colors for dark mode - more visible and softer (with bold)
        declare -g FOREST_GREEN="\[\033[1;38;5;120m\]"    # Bold bright green for arrows & success
        declare -g OCEAN_BLUE="\[\033[1;38;5;81m\]"       # Bold cyan-blue for happy mood & ocean animals  
        declare -g TIGER_ORANGE="\[\033[1;38;5;215m\]"    # Bold light orange for paths & colorful animals
        declare -g BEAR_BROWN="\[\033[1;38;5;180m\]"      # Bold light brown for brown animals
        declare -g CHERRY_RED="\[\033[1;38;5;203m\]"      # Bold pink-red for error states & sad mood
        declare -g PURPLE="\[\033[1;38;5;141m\]"          # Bold light purple for git branches
    else
        # Darker colors for light mode (original palette with bold)
        declare -g FOREST_GREEN="\[\033[1;38;5;22m\]"     # Bold arrows & success elements
        declare -g OCEAN_BLUE="\[\033[1;38;5;26m\]"       # Bold happy mood & ocean animals  
        declare -g TIGER_ORANGE="\[\033[1;38;5;208m\]"    # Bold paths & colorful animals
        declare -g BEAR_BROWN="\[\033[1;38;5;94m\]"       # Bold brown animals
        declare -g CHERRY_RED="\[\033[1;38;5;160m\]"      # Bold error states & sad mood
        declare -g PURPLE="\[\033[1;38;5;93m\]"           # Bold git branches
    fi
}

# Initialize colors based on current mode
set_color_palette

# Emoji Collections (Organized by Color Theme)
# ----------------------------------------------------------------------------
declare -ra BROWN_ANIMALS=(🐶 🐺 🐻 🐵 🦊 🐴)
declare -ra GRAY_ANIMALS=(🐭 🐹 🐰 🐨 🐼 🐧) 
declare -ra COLORFUL_ANIMALS=(🐸 🐷 🐮)
declare -ra OCEAN_ANIMALS=(🐙 🐠 🐳 🐬)
declare -ra GOLDEN_ANIMALS=(🐥 🐱 🐯 🦁)

# Mood Indicator Logic
# ----------------------------------------------------------------------------
# State tracking for detecting empty commands
PREVIOUS_HISTORY_NUMBER=0

# Session-consistent theme variables (set once per shell process)
SESSION_EMOJI=""
SESSION_PATH_COLOR=""

get_mood_indicator() {
    local command_exit_code=$1
    local current_history_number=$2
    
    # Show happy face if just pressing Enter (no new command in history)
    if [[ "$current_history_number" == "$PREVIOUS_HISTORY_NUMBER" ]]; then
        echo "${OCEAN_BLUE} ^.^ ${NO_COLOR}"
        return
    fi
    
    # Show mood based on command success/failure
    if [[ $command_exit_code -eq 0 ]]; then
        echo "${OCEAN_BLUE} ^.^ ${NO_COLOR}"  # Happy - command succeeded
    else
        echo "${CHERRY_RED} O.O ${NO_COLOR}"  # Sad - command failed
    fi
}

# Random Emoji Selection
# ----------------------------------------------------------------------------
get_random_emoji_from_group() {
    local group_name="$1"
    local color="$2"
    
    # Use eval for indirect array access (compatible with older bash)
    local emoji_list
    eval "emoji_list=(\"\${${group_name}[@]}\")"
    
    # Safety check
    if [[ ${#emoji_list[@]} -eq 0 ]]; then
        echo "${TIGER_ORANGE}🐶${NO_COLOR}"
        return
    fi
    
    local random_emoji="${emoji_list[$RANDOM % ${#emoji_list[@]}]}"
    echo "${color}${random_emoji}${NO_COLOR}"
}

initialize_session_theme() {
    # Define emoji groups with their matching colors
    local groups=(
        "BROWN_ANIMALS:$BEAR_BROWN"
        "GRAY_ANIMALS:$NO_COLOR" 
        "COLORFUL_ANIMALS:$TIGER_ORANGE"
        "OCEAN_ANIMALS:$OCEAN_BLUE"
        "GOLDEN_ANIMALS:$TIGER_ORANGE"
    )
    
    # Pick random group for this shell session
    local selected_group="${groups[$RANDOM % ${#groups[@]}]}"
    local group_name="${selected_group%:*}"
    local group_color="${selected_group#*:}"
    
    # Set session variables (these will persist for the entire shell session)
    SESSION_EMOJI=$(get_random_emoji_from_group "$group_name" "$group_color")
    SESSION_PATH_COLOR="$group_color"
}

# Initialize theme once when shell starts (not inherited by new processes)
if [[ -z "$SESSION_EMOJI" || "$BASH_SUBSHELL" == "0" ]]; then
    initialize_session_theme
fi

# Git Branch Helper
# ----------------------------------------------------------------------------
get_git_branch() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Git Status Icons
# ----------------------------------------------------------------------------
# Icon meanings:
# ● - Modified/dirty files (uncommitted changes)
# + - Staged files (ready to commit)
# ? - Untracked files (not in git)
# ↑3 - Commits ahead of remote
# ↓2 - Commits behind remote
get_git_status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local status=""
        # Check for uncommitted changes
        if ! git diff --quiet 2>/dev/null; then
            status+="●"  # Modified files
        fi
        # Check for staged changes
        if ! git diff --cached --quiet 2>/dev/null; then
            status+="+"  # Staged files
        fi
        # Check for untracked files
        if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
            status+="?"  # Untracked files
        fi
        # Check if ahead/behind remote
        local ahead_behind=$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
        if [[ -n "$ahead_behind" ]]; then
            local ahead=$(echo "$ahead_behind" | cut -f1)
            local behind=$(echo "$ahead_behind" | cut -f2)
            [[ "$ahead" -gt 0 ]] && status+="↑$ahead"
            [[ "$behind" -gt 0 ]] && status+="↓$behind"
        fi
        [[ -n "$status" ]] && echo " $status"
    fi
}

# Main Prompt Builder
# ----------------------------------------------------------------------------
build_bash_prompt() {
    local last_command_exit_code=$?
    local current_history_number
    current_history_number=$(history 1 | awk '{print $1}' 2>/dev/null || echo "0")
    
    # Get current timestamp in macOS format
    local timestamp=$(date '+%a %b %d %l:%M %p' | sed 's/  / /g')
    
    # Get mood indicator based on command result
    local mood_face
    mood_face=$(get_mood_indicator "$last_command_exit_code" "$current_history_number")
    
    # Get git status icons
    local git_status_icons=$(get_git_status)
    
    # Update history tracking
    PREVIOUS_HISTORY_NUMBER="$current_history_number"
    
    # Assemble the prompt using session-consistent theme with bold formatting: [timestamp] [mood] [colored_path] [git_branch] [git_status] [emoji] [arrow]
    PS1="${BOLD}${TIGER_ORANGE}${timestamp}${NO_COLOR}${mood_face}${SESSION_PATH_COLOR}\w${PURPLE}\$(get_git_branch)${CHERRY_RED}${git_status_icons}${NO_COLOR} ${SESSION_EMOJI} ${FOREST_GREEN}⤷${NO_COLOR} "
}
PROMPT_COMMAND=build_bash_prompt

# ==============================================================================
# SYSTEM ALIASES
# ==============================================================================

alias n=nvim
alias e=nvim
alias saver='open -a ScreenSaverEngine'
alias ss='open -a ScreenSaverEngine'
alias myip='curl https://wtfismyip.com/json | jq'
alias vtop="vtop --theme brew"
alias crontab="VIM_CRONTAB=true crontab"

# System update
update() {
    softwareupdate -i -a
    brew update && brew upgrade && brew cleanup
}

# Port check - usage: p 8081
p() { lsof -i tcp:"$1"; }

# ==============================================================================
# NAVIGATION ALIASES
# ==============================================================================

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias ~='cd ~'
alias home='cd ~'
alias f='open -a Finder ./'

# File listing (using eza)
alias l='eza -lhF --git'
alias la='eza -lahF --git'

# File viewing
alias c='cursor'
alias b='bat'
alias cat='bat'

# File operations
alias mkdir='mkdir -pv'
alias o='open'
alias md='open -a macdown'

# Tree view
alias tree='tree -C'
alias t='tree -L 2 --filelimit 30 -F --dirsfirst'
tree_example() { echo "t -I 'node_modules|coverage' -L 4 -P 'package.*'"; }

# ==============================================================================
# GIT ALIASES
# ==============================================================================

# Basic git shortcuts
alias g='git'
alias gi='git'
alias got='git'
alias get='git'

# Git status and info
alias gs='git status'
alias gb='git branch -vv'
alias gr='git remote -v'
alias gd='git diff'

# Git operations
alias ga='git add'
alias gc='git commit -m'
alias gco='git checkout'
alias go='git checkout'
alias gob='git checkout -b'
alias g-='git checkout -'
alias gcp='git cherry-pick'
alias gre='git rebase -i'
alias gds='git diff --staged'

# Git push/pull
alias gp='git push'
alias gps='git push'
alias gpso='git push o'
alias gpl='git pull'

# Git cleanup and maintenance
alias grmall='git rm $(git ls-files -d)'
alias gprune="git remote update origin --prune"

# Git log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Git GUI
alias gk='gitk --all&'
alias gx='gitx --all'

# Git completion  
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# Enhanced bash completion (install with: brew install bash-completion@2)
if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then
    . "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

# ==============================================================================
# DEVELOPMENT ALIASES
# ==============================================================================

# Yarn shortcuts
alias y='yarn'

# Android development
alias emulator="$ANDROID_HOME/tools/emulator"
alias emulators="$ANDROID_HOME/tools/emulator -list-avds"
alias run-emulator='emulator @$(emulators)'
alias deeplink='xcrun simctl openurl booted'

# ==============================================================================
# ENHANCED NAVIGATION
# ==============================================================================

# Enhanced z with file listing and git status
zo() {
    z "$@"
    printf "\n"
    eza -lhF --git
    printf "\n"
    gs
}
alias z=zo
alias zz='z -c'
alias zi='z -I'
alias zb='z -b'

# Enhanced cd with tree view and ls
cd() {
    builtin cd "$@"
    t
    [ $? -eq 0 ] && ls --color=auto
}

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# Toggle between light and dark color palettes
toggle_colors() {
    if [[ "${FOREST_GREEN}" == *"120"* ]]; then
        # Currently in dark mode colors, switch to light
        echo "Switching to light mode colors..."
        declare -g FOREST_GREEN="\[\033[38;5;22m\]"     # Arrows & success elements
        declare -g OCEAN_BLUE="\[\033[38;5;26m\]"       # Happy mood & ocean animals  
        declare -g TIGER_ORANGE="\[\033[38;5;208m\]"    # Paths & colorful animals
        declare -g BEAR_BROWN="\[\033[38;5;94m\]"       # Brown animals
        declare -g CHERRY_RED="\[\033[38;5;160m\]"      # Error states & sad mood
        declare -g PURPLE="\[\033[38;5;93m\]"           # Git branches
    else
        # Currently in light mode colors, switch to dark
        echo "Switching to dark mode colors..."
        declare -g FOREST_GREEN="\[\033[38;5;120m\]"    # Bright green for arrows & success
        declare -g OCEAN_BLUE="\[\033[38;5;81m\]"       # Cyan-blue for happy mood & ocean animals  
        declare -g TIGER_ORANGE="\[\033[38;5;215m\]"    # Light orange for paths & colorful animals
        declare -g BEAR_BROWN="\[\033[38;5;180m\]"      # Light brown for brown animals
        declare -g CHERRY_RED="\[\033[38;5;203m\]"      # Pink-red for error states & sad mood
        declare -g PURPLE="\[\033[38;5;141m\]"          # Light purple for git branches
    fi
    
    # Reinitialize the session theme with new colors
    initialize_session_theme
    
    # Force prompt refresh
    PROMPT_COMMAND=build_bash_prompt
}

# Force light or dark mode
light_mode() {
    echo "Forcing light mode colors..."
    declare -g FOREST_GREEN="\[\033[38;5;22m\]"     
    declare -g OCEAN_BLUE="\[\033[38;5;26m\]"       
    declare -g TIGER_ORANGE="\[\033[38;5;208m\]"    
    declare -g BEAR_BROWN="\[\033[38;5;94m\]"       
    declare -g CHERRY_RED="\[\033[38;5;160m\]"      
    declare -g PURPLE="\[\033[38;5;93m\]"           
    initialize_session_theme
}

dark_mode() {
    echo "Forcing dark mode colors..."
    declare -g FOREST_GREEN="\[\033[38;5;120m\]"    
    declare -g OCEAN_BLUE="\[\033[38;5;81m\]"       
    declare -g TIGER_ORANGE="\[\033[38;5;215m\]"    
    declare -g BEAR_BROWN="\[\033[38;5;180m\]"      
    declare -g CHERRY_RED="\[\033[38;5;203m\]"      
    declare -g PURPLE="\[\033[38;5;141m\]"          
    initialize_session_theme
}

# Open localhost with port (default 8000)
localhost() {
    local port="${1:-8000}"
    open "http://localhost:${port}/"
}
# Localhost shortcut
alias h=localhost

# Simple calculator
calc() {
    local result
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
    if [[ "$result" == *.* ]]; then
        printf '\n     %s\n' "$result" | sed -e 's/^\./0./' -e 's/^-\./-0./' -e 's/0*$//;s/\.$//'
    else
        printf '\n     %s\n' "$result"
    fi
    printf "\n"
}

# Dictionary lookup
define() { open dict://"${1}"; }
alias d=define

# Show most used commands
most_used_commands() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
    grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}
alias most=most_used_commands

# Show what every letter of the alphabet does
alphabet_commands() {
    echo ""
    echo "🔤 Alphabet Command Reference"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    for letter in {a..z}; do
        local cmd_info=""
        
        # Check if it's an alias
        if alias "$letter" &>/dev/null; then
            cmd_info="$(alias "$letter" | sed "s/alias $letter='//" | sed "s/'$//")"
            cmd_info="→ $cmd_info (alias)"
        # Check if it's a function
        elif declare -F "$letter" &>/dev/null; then
            cmd_info="→ function (use 'declare -f $letter' to see code)"
        # Check if it's a built-in command
        elif type "$letter" &>/dev/null; then
            local cmd_type=$(type "$letter" 2>/dev/null | head -1)
            if [[ "$cmd_type" == *"builtin"* ]]; then
                cmd_info="→ bash builtin"
            elif [[ "$cmd_type" == *"function"* ]]; then
                cmd_info="→ function"
            elif [[ "$cmd_type" == *"/"* ]]; then
                cmd_info="→ $(echo "$cmd_type" | awk '{print $NF}') (external command)"
            else
                cmd_info="→ $cmd_type"
            fi
        else
            cmd_info="→ not defined"
        fi
        
        printf "%-3s %s\n" "$letter:" "$cmd_info"
    done
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Use 'alias', 'declare -F', or 'type <command>' for more details"
    echo ""
}
alias a=alphabet_commands

# ==============================================================================
# CLOUD SDK
# ==============================================================================

# Google Cloud SDK
if [ -f '/Users/jonny/google-cloud-sdk/path.bash.inc' ]; then
    . '/Users/jonny/google-cloud-sdk/path.bash.inc'
fi

if [ -f '/Users/jonny/google-cloud-sdk/completion.bash.inc' ]; then
    . '/Users/jonny/google-cloud-sdk/completion.bash.inc'
fi

# Tip of the Day
# ----------------------------------------------------------------------------
declare -ra DAILY_TIPS=(
    # Navigation & File Operations
    "� Use 'z <partial_name>' to quickly jump to frequently used directories"
    "🌳 Run 't' to see a clean tree view (2 levels, 30 files max)"
    "� Use 'f' to open current directory in Finder"
    "⬆️ Use '..' '...' '....' to go up 1, 2, or 3 directories"
    "🏠 Type '~' or 'home' to quickly go to your home directory"
    "📊 Use 'l' or 'la' for beautiful file listings with git status"
    "👁️ Use 'b' or 'cat' for syntax-highlighted file viewing with bat"
    "📝 Use 'c' to open current directory in Cursor editor"
    "📄 Use 'md' to open markdown files in MacDown"
    "🔍 Use 'o <file>' to open any file with default application"
    
    # Git Workflow
    "🔍 Try 'gs' for git status or 'gl' for beautiful commit history"
    "🌿 Use 'gb' to see all branches with tracking info"
    "🔄 Use 'gp' to push or 'gpl' to pull changes"
    "🔧 Use 'gds' to see staged git changes before committing"
    "📝 Use 'ga <file>' to add files, 'gc \"message\"' to commit"
    "🚀 Use 'go <branch>' or 'gco <branch>' to checkout branches"
    "✨ Use 'gob <name>' to create and checkout new branch"
    "⏪ Use 'g-' to switch to previous branch quickly"
    "🍒 Use 'gcp <hash>' for cherry-picking commits"
    "🔄 Use 'gre' for interactive rebase"
    "🧹 Use 'gprune' to clean up remote tracking branches"
    
    # Development Shortcuts
    "⚡ Use 'y' instead of 'yarn' and 'n' or 'e' instead of 'nvim' for speed"
    "📝 Use 'e file.txt' to edit files - short for 'edit' and feels intuitive"
    "🔗 Use 'deeplink <url>' to test deep links in iOS simulator"
    "📱 Use 'run-emulator' to start Android emulator"
    "📋 Use 'emulators' to list available Android virtual devices"
    
    # System & Utilities
    "🎨 Use 'toggle_colors' to switch between light and dark themes"
    "☀️ Use 'light_mode' or 'dark_mode' to force color schemes"
    "🧮 Type 'calc 2+2*3' for quick calculations in terminal"
    "📖 Use 'd word' or 'define word' to look up definitions"
    "🔄 Run 'most' to see your most used commands"
    "🌐 Use 'h 3000' or 'localhost 3000' to open localhost:3000 in browser (any port)"
    "🏠 'h' is perfect for localhost - short, memorable, and intuitive"
    "📊 Try 'vtop' for beautiful process monitor"
    "� Use 'myip' to get your public IP address with details"
    "🔌 Use 'p 8080' to see what's running on port 8080"
    "💤 Use 'saver' or 'ss' to start screensaver"
    "🔄 Use 'update' to update macOS and Homebrew packages"
    
    # Advanced Navigation
    "🎯 Use 'zo <dir>' for z + file listing + git status"
    "📊 Use 'zi' for z with interactive selection"
    "📚 Use 'zb' to jump to bookmark directory"
    "🧹 Use 'zz' to clean z database"
    "🌳 Enhanced 'cd' shows tree view + file listing automatically"
    
    # Prompt & Customization
    "🎲 Your prompt shows random emoji themes per session!"
    "😊 Prompt mood changes: ^.^ for success, O.O for errors"
    "🕐 Your prompt shows timestamp, git status, and branch info"
    "✨ Git status icons: ● (modified), + (staged), ? (untracked)"
    "📈 Git shows ↑3 (ahead) and ↓2 (behind) remote counts"
    
    # Hidden Gems
    "⬆️ Press Ctrl+R to search through command history"
    "� Your 'mkdir' automatically creates parent directories (-pv)"
    "🌲 Use tree with filters: 't -I \"node_modules\" -L 4'"
    "📝 'crontab' is enhanced to work better with vim"
    "🔧 Git tab completion is enabled for branches and commands"
    "💡 Type 'tree_example' to see advanced tree usage examples"
    "🔤 Use 'a' to see what every letter of the alphabet does as a command"

    # Fun Features
    "🎲 Use 'random_tip' to get a random tip instead of daily"
    "🎨 Your terminal auto-detects light/dark mode for colors"
    "🦁 Your prompt emoji rotates between animal themes!"
    "⚡ Many commands have shortcuts: 'gi'='git', 'got'='git', 'get'='git'"
    "⬆️ Press Ctrl+R to search through command history"
    "🔍 Use Ctrl+T for fuzzy file search while typing - game changer!"
    "📁 Use Alt+C for fuzzy directory search and instant cd"
    "🎯 Enhanced tab completion works with git branches, commands, and files"
    "� Your 'mkdir' automatically creates parent directories (-pv)"
)

# Tip display mode (daily or random)
TIP_MODE="random"  # Can be "daily" or "random"

# Toggle between daily and random tip modes
random_tip() {
    if [[ "$TIP_MODE" == "daily" ]]; then
        TIP_MODE="random"
        echo "🎲 Switched to random tips! New terminals will show random tips."
    else
        TIP_MODE="daily"
        echo "📅 Switched to daily tips! New terminals will show daily tips."
    fi
    show_tip_of_day  # Show a tip immediately
}

show_tip_of_day() {
    local day_seed tip_index
    
    if [[ "$TIP_MODE" == "random" ]]; then
        # Use random seed for random tips
        tip_index=$((RANDOM % ${#DAILY_TIPS[@]}))
    else
        # Use date as seed for consistent tip per day
        day_seed=$(date +%j)  # Day of year (1-366)
        tip_index=$((day_seed % ${#DAILY_TIPS[@]}))
    fi
    
    # Define colors for regular echo (without prompt brackets)
    local orange="\033[1;38;5;208m"  # Orange color for light mode
    local reset="\033[0m"           # Reset color
    local mode_indicator="📅 Daily"
    
    if [[ "$TIP_MODE" == "random" ]]; then
        mode_indicator="🎲 Random"
    fi
    
    echo ""
    echo -e "${orange}┌─ ${mode_indicator} Tip ──────────────────────────────────────┐${reset}"
    echo -e "${orange}│${reset} ${DAILY_TIPS[$tip_index]}"
    echo -e "${orange}└─────────────────────────────────────────────────────┘${reset}"
    echo -e "${orange}💡 Type 'random_tip' to toggle between daily/random tips${reset}"
    echo ""
}

# ==============================================================================
# ENHANCED BASH COMPLETION
# ==============================================================================

# Custom completion function that includes all commands, aliases, and functions
_comprehensive_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Get all available commands, aliases, and functions
    local commands=($(compgen -c | sort -u))
    local aliases=($(alias | cut -d'=' -f1 | sed 's/^alias //'))
    local functions=($(declare -F | awk '{print $3}'))
    local builtins=($(compgen -b))
    
    # Combine all completions
    local all_completions=("${commands[@]}" "${aliases[@]}" "${functions[@]}" "${builtins[@]}")
    
    # Generate completions based on current word
    COMPREPLY=($(compgen -W "${all_completions[*]}" -- "$cur"))
    
    # Also include file/directory completions
    COMPREPLY+=($(compgen -f -- "$cur"))
}

# Enhanced command discovery function
query() {
    local search_term="$1"
    
    if [[ -z "$search_term" ]]; then
        echo "Usage: query <search_term>"
        echo "Examples:"
        echo "  query git    - Find all git-related commands"
        echo "  query docker - Find all docker commands"
        echo "  query node   - Find all node-related tools"
        return 1
    fi
    
    echo ""
    echo "🔍 Discovering commands containing '$search_term':"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Search in commands
    echo "📦 Commands in PATH:"
    compgen -c | grep -i "$search_term" | sort -u | head -20 | sed 's/^/  • /'
    
    # Search in aliases
    echo ""
    echo "🔗 Your Aliases:"
    alias | grep -i "$search_term" | sed 's/alias /  • /' | head -10
    
    # Search in functions
    echo ""
    echo "⚙️  Your Functions:"
    declare -F | awk '{print $3}' | grep -i "$search_term" | sed 's/^/  • /' | head -10
    
    # Search in brew packages
    if command -v brew &> /dev/null; then
        echo ""
        echo "🍺 Homebrew Packages:"
        brew list | grep -i "$search_term" | sed 's/^/  • /' | head -10
    fi
    
    echo ""
    echo "💡 Use tab completion after typing '$search_term' to see more options"
    echo ""
}

# Quick command existence checker
exists() {
    for cmd in "$@"; do
        if command -v "$cmd" &> /dev/null; then
            echo "✅ $cmd: $(command -v "$cmd")"
        else
            echo "❌ $cmd: not found"
        fi
    done
}

# Enhanced which that shows more info
which_enhanced() {
    for cmd in "$@"; do
        echo "🔍 Analyzing: $cmd"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Check if it's an alias
        if alias "$cmd" &>/dev/null; then
            echo "📎 Alias: $(alias "$cmd" | sed "s/alias $cmd='//" | sed "s/'$//")"
        fi
        
        # Check if it's a function
        if declare -F "$cmd" &>/dev/null; then
            echo "⚙️  Function: Use 'declare -f $cmd' to see code"
        fi
        
        # Check type and location
        if command -v "$cmd" &> /dev/null; then
            local cmd_path=$(command -v "$cmd")
            echo "📍 Location: $cmd_path"
            
            # Show file info if it's a real file
            if [[ -f "$cmd_path" ]]; then
                echo "📊 File size: $(du -h "$cmd_path" | cut -f1)"
                echo "📅 Modified: $(stat -f "%Sm" "$cmd_path")"
                
                # Show first few lines if it's a script
                if file "$cmd_path" | grep -q "text"; then
                    echo "📄 First few lines:"
                    head -5 "$cmd_path" | sed 's/^/     /'
                fi
            fi
        else
            echo "❌ Command not found"
        fi
        echo ""
    done
}

# Function to show all available commands with pagination
show_all_commands() {
    echo "🗂️  All Available Commands, Aliases, and Functions:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    {
        echo "=== ALIASES ==="
        alias | sort
        echo ""
        echo "=== FUNCTIONS ==="
        declare -F | awk '{print $3}' | sort
        echo ""
        echo "=== COMMANDS IN PATH ==="
        compgen -c | sort -u
    } | less
}

# Aliases for the new functions
alias q=query
alias w=which_enhanced
alias all=show_all_commands

# Set up enhanced completion for common commands that don't have it
# This applies comprehensive completion to commands that typically only complete files
complete -F _comprehensive_completion cd ls cat less more head tail grep find

# Show tip when starting new shell (not in subshells)
if [[ -z "$BASH_SUBSHELL" || "$BASH_SUBSHELL" == "0" ]]; then
    show_tip_of_day
    a
fi

