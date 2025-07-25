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
    PS1="${BOLD}${TIGER_ORANGE}${timestamp}${NO_COLOR} ${mood_face}${SESSION_PATH_COLOR}\w${PURPLE}\$(get_git_branch)${CHERRY_RED}${git_status_icons}${NO_COLOR} ${SESSION_EMOJI} ${FOREST_GREEN}⤷${NO_COLOR} "
}
PROMPT_COMMAND=build_bash_prompt

# ==============================================================================
# SYSTEM ALIASES
# ==============================================================================

alias n=nvim
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
alias e='eza -lh --git'

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

# ==============================================================================
# DEVELOPMENT ALIASES
# ==============================================================================

# Yarn shortcuts
alias y='yarn'
alias yy='yarn && cd ios && pod install && ..'
alias yyi='yarn && cd ios && pod install && .. && y ios && y start'
alias yyd='yarn && cd ios && pod install && .. && y ios --device && y start'
alias yya='yarn && y android'
alias yyy='yarn reset && yarn && yarn bootstrap'

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
s() {
    local port="${1:-8000}"
    open "http://localhost:${port}/"
}

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
d() { define "$1"; }

# Show most used commands
most_used_commands() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
    grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}
alias most=most_used_commands

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

