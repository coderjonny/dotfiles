#!/usr/bin/env bash

# ==============================================================================
# JONNY'S BASH PROFILE
# ==============================================================================

# Source .bashrc if it exists
[ -r ~/.bashrc ] && . ~/.bashrc

# Bash Cheat Sheet
# ----------------------------------------------------------------------------
# -n  # "not empty" (negative logic)
# -z  # "zero length" (zero logic)
# -e  # "exists" (file test)
# -f  # "file" (regular file)
# -d  # "directory"
# -r  # "readable"
# -w  # "writable"
# -x  # "executable"

# ----------------------------------------------------------------------------
# String tests
# ----------------------------------------------------------------------------
# [[ -n "$var" ]]    # String is NOT empty
# [[ -z "$var" ]]    # String IS empty
# [[ "$var" == "value" ]]  # String equals
# [[ "$var" != "value" ]]  # String not equals

# # File tests
# [[ -e "file" ]]    # File exists
# [[ -f "file" ]]    # Regular file exists
# [[ -d "dir" ]]     # Directory exists
# [[ -r "file" ]]    # File is readable
# [[ -w "file" ]]    # File is writable
# [[ -x "file" ]]    # File is executable

# # Integer tests
# [[ $num -eq 0 ]]   # Equal
# [[ $num -ne 0 ]]   # Not equal
# [[ $num -gt 0 ]]   # Greater than
# [[ $num -lt 0 ]]   # Less than
# [[ $num -ge 0 ]]   # Greater or equal
# [[ $num -le 0 ]]   # Less or equal


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
[[ -z "$NO_COLOR" ]] && declare -r NO_COLOR="\[\033[0m\]"
[[ -z "$BOLD" ]] && declare -r BOLD="\[\033[1m\]"

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
[[ -z "$BROWN_ANIMALS" ]] && declare -ra BROWN_ANIMALS=(🐶 🐺 🐻 🐵 🦊 🐴)
[[ -z "$GRAY_ANIMALS" ]] && declare -ra GRAY_ANIMALS=(🐭 🐹 🐰 🐨 🐼 🐧)
[[ -z "$COLORFUL_ANIMALS" ]] && declare -ra COLORFUL_ANIMALS=(🐸 🐷 🐮)
[[ -z "$OCEAN_ANIMALS" ]] && declare -ra OCEAN_ANIMALS=(🐙 🐠 🐳 🐬)
[[ -z "$GOLDEN_ANIMALS" ]] && declare -ra GOLDEN_ANIMALS=(🐥 🐱 🐯 🦁)

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
    # Sed expression to delete all lines that don't start with '*' (the current branch marker)
    local filter_current_branch='/^[^*]/d'

    # Sed expression to extract the branch name (e.g., "main") from "* main"
    # and format it as "(main)". The asterisk is escaped for clarity.
    local format_branch_name='s/\* \(.*\)/(\1)/'

    # Run sed with the expressions stored in variables. Note the double quotes
    # to allow the shell to expand the variables.
    git branch --no-color 2>/dev/null | sed -e "$filter_current_branch" -e "$format_branch_name"
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

        if [[ -z "$status" ]]; then
            echo "${FOREST_GREEN}●${NO_COLOR}"
        else
            echo "$status"
        fi
    fi
}

# Git History Helper
# ----------------------------------------------------------------------------
get_git_mini_log() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo ""
        git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -1 2>/dev/null
    fi
}

# Tropical Surf Paradise Circadian-Linear Clock
# ----------------------------------------------------------------------------
get_tropical_surf_clock() {
    local hour_24=$((10#$(date '+%H')))

    # Build the progress bar - range depends on current time
    local surf_bar=""

    # For current hour, show time instead of just hour number
    local current_time
    current_time=$(date '+%l:%M%p' | sed 's/ //g' | tr '[:upper:]' '[:lower:]')

    # Get 12-hour format for clock emoji selection
    local hour_12=$(date '+%l' | sed 's/ //g')

    # Choose time range based on current hour
    local time_range
    if [[ $hour_24 -ge 6 && $hour_24 -le 22 ]]; then
        # Day hours (6am - 10pm)
        time_range=(6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
    else
        # Night hours (10pm - 6am)
        time_range=(22 23 0 1 2 3 4 5 6)
    fi

    for hour in "${time_range[@]}"; do
        local display_hour=$hour
        if [[ $hour == 0 ]]; then
            display_hour=12  # Midnight
        elif [[ $hour -gt 12 ]]; then
            display_hour=$((hour-12))
        fi

        # Declare each hour's default emoji (declarative approach)
        local hour_emoji=""
        case $hour in
            0|1|2|3|4|5) hour_emoji="🌙" ;; # Crescent moon (midnight-5am)
            6) hour_emoji="🌅" ;;           # Sunrise
            7|8|9|10|11) hour_emoji="🌊" ;; # Morning waves (7am-11am)
            12) hour_emoji="🏖️" ;;          # Lunch break
            13|14|15|16|17) hour_emoji="🌊" ;; # Afternoon waves (1pm-5pm)
            18) hour_emoji="🌇" ;;          # Sunset
            19|20|21|22|23) hour_emoji="🌺" ;; # Evening flowers (7pm-11pm)
            *) hour_emoji="🌊" ;;           # Default waves
        esac

        # Override logic: Past hours become blue dots, current hour becomes surfer
        local is_past_hour=false

        # Check if this hour is in the past (handle 24-hour wraparound)
        if [[ $hour_24 -ge 6 ]]; then
            # Current time is 6am-11pm: past hours are any hour less than current AND >= 6
            if [[ $hour -lt $hour_24 && $hour -ge 6 ]]; then
                is_past_hour=true
            fi
        else
            # Current time is midnight-5am: past hours are 6am-11pm OR hours less than current
            if [[ $hour -ge 6 ]] || [[ $hour -lt $hour_24 ]]; then
                is_past_hour=true
            fi
        fi

        if [[ $is_past_hour == true ]]; then
            hour_emoji="${OCEAN_BLUE}•"  # All past hours become blue dots
        elif [[ $hour_24 == $hour ]]; then
            hour_emoji="🏄‍♂️"  # Current hour becomes surfer
        fi

        # Add hour markers and handle current hour time display
        if [[ $hour_emoji == "🏄‍♂️" ]]; then
            # Get clock emoji for current hour
            local clock_emoji=""
            if [[ "$hour_24" == "12" ]]; then
                clock_emoji="🕛"
            else
                case "$hour_12" in
                    1) clock_emoji="🕐" ;;
                    2) clock_emoji="🕑" ;;
                    3) clock_emoji="🕒" ;;
                    4) clock_emoji="🕓" ;;
                    5) clock_emoji="🕔" ;;
                    6) clock_emoji="🕕" ;;
                    7) clock_emoji="🕖" ;;
                    8) clock_emoji="🕗" ;;
                    9) clock_emoji="🕘" ;;
                    10) clock_emoji="🕙" ;;
                    11) clock_emoji="🕚" ;;
                    12) clock_emoji="🕛" ;;  # This will be 12am (midnight)
                    *) clock_emoji="🕐" ;;   # Default fallback
                esac
            fi
            surf_bar+=" [${clock_emoji} ${current_time}] ${hour_emoji}"
        else
            surf_bar+=" ${display_hour} ${hour_emoji}"
        fi
    done

    echo "${surf_bar}"
}

# Main Prompt Builder
# ----------------------------------------------------------------------------
build_bash_prompt() {
    local last_command_exit_code=$?
    local current_history_number
    current_history_number=$(history 1 | awk '{print $1}' 2>/dev/null || echo "0")

    # Get tropical surf clock for testing
    local surf_clock=$(get_tropical_surf_clock)


    # Get mood indicator based on command result
    local mood_face
    mood_face=$(get_mood_indicator "$last_command_exit_code" "$current_history_number")

    # Get git status icons
    local icons
    icons=$(get_git_status)

    # Update history tracking
    PREVIOUS_HISTORY_NUMBER="$current_history_number"

    # Show mini git log above each prompt
    get_git_mini_log

    # Assemble the prompt using session-consistent theme with bold formatting
    # local clock=" ${hour_emoji}"
    local surf_section="${BOLD}${OCEAN_BLUE}${surf_clock}${NO_COLOR}"
    local mood_section="${mood_face}"
    local path_section="${SESSION_PATH_COLOR}\w"
    local git_section="${PURPLE}\$(get_git_branch)${CHERRY_RED}${icons}${NO_COLOR}"
    local emoji_section="${SESSION_EMOJI}"
    local arrow_section="${FOREST_GREEN}⤷${NO_COLOR} "

    # Option 1: Single line (original)
    # PS1="${timestamp_section} | ${surf_section} | ${mood_section}${path_section}${git_section} ${emoji_section} ${arrow_section}"

    # Option 2: Multiline prompt (more readable for complex info)
    PS1="${surf_section}\n${mood_section}${path_section}${git_section} ${emoji_section} ${arrow_section}"
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
alias ip='curl https://wtfismyip.com/json | jq'
alias vtop="vtop --theme brew"
alias crontab="VIM_CRONTAB=true crontab"
alias r=". ~/.bash_profile"

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
alias c='bat'
alias b='bat'
alias cat='bat'

# File operations
alias mkdir='mkdir -pv'
alias o='open'
alias md='open -a macdown'

# Tree view
alias tree='tree -C'
alias t='tree -aLF 1 --dirsfirst'
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
alias s='git status'
alias gs='git status'
alias gb='git branch -vv'
alias gr='git remote -v'
alias gd='git diff'

# Git operations
alias ga='git add'
alias gc='git commit -m'
alias gco='git checkout'
# alias go='git checkout' # using go
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
    # eza -lhF --git
    t
    printf "\n"
    gs
    get_git_mini_log
}
alias z=zo
alias zz='z -c'
alias zi='z -I'
alias zb='z -b'

# Enhanced cd with tree view and ls
cd() {
    builtin cd "$@"
    t
    # [ $? -eq 0 ] && ls --color=auto
    # Show mini git log after each prompt
    gs
    get_git_mini_log
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
        declare -g CHERRY_RED="\[\033[38;5;160m\]"       # Error states & sad mood
        declare -g PURPLE="\[\033[38;5;93m\]"           # Git branches
    else
        # Currently in light mode colors, switch to dark
        echo "Switching to dark mode colors..."
        declare -g FOREST_GREEN="\[\033[38;5;120m\]"    # Bright green for arrows & success
        declare -g OCEAN_BLUE="\[\033[38;5;81m\]"       # Cyan-blue for happy mood & ocean animals
        declare -g TIGER_ORANGE="\[\033[38;5;215m\]"     # Light orange for paths & colorful animals
        declare -g BEAR_BROWN="\[\033[38;5;180m\]"       # Light brown for brown animals
        declare -g CHERRY_RED="\[\033[38;5;203m\]"       # Pink-red for error states & sad mood
        declare -g PURPLE="\[\033[38;5;141m\]"           # Light purple for git branches
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
alias host=localhost

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
[[ -z "$DAILY_TIPS" ]] && declare -ra DAILY_TIPS=(
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
    "🔍 Try 's' or 'gs' for git status - ultra-short for frequent use"
    "🎨 Use 'gl' for beautiful commit history with graphs and colors"
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

# Vocabulary of the Day
# ----------------------------------------------------------------------------
[[ -z "$DAILY_VOCAB" ]] && declare -ra DAILY_VOCAB=(
    # Programming & Tech Terms
    "📝 Idempotent|adj.|/aɪˈdɛmpətənt/|Producing the same result when applied multiple times (e.g., REST API calls)"
    "🔄 Polymorphism|noun|/ˌpɒlɪˈmɔːfɪzəm/|The ability of different objects to respond to the same interface in different ways"
    "⚡ Asynchronous|adj.|/eɪˈsɪŋkrənəs/|Operations that don't block execution while waiting for completion"
    "🎯 Algorithm|noun|/ˈælɡərɪðəm/|A step-by-step procedure for solving a problem or completing a task"
    "🏗️ Architecture|noun|/ˈɑːrkɪtektʃər/|The fundamental organization of a system and its components"
    "📊 Heuristic|noun|/hjʊˈrɪstɪk/|A problem-solving approach using practical methods to find satisfactory solutions"
    "🔍 Recursion|noun|/rɪˈkɜːrʒən/|A programming technique where a function calls itself to solve smaller subproblems"
    "⚙️ Concatenate|verb|/kənˈkætəneɪt/|To link or join together in a series (especially strings or arrays)"
    "🎨 Paradigm|noun|/ˈpærədaɪm/|A fundamental style or approach to programming (e.g., functional, object-oriented)"
    "🔐 Cryptography|noun|/krɪpˈtɒɡrəfi/|The practice of securing communication through encoding information"

    # Business & Professional Terms
    "📈 Synergy|noun|/ˈsɪnərdʒi/|The combined effect is greater than the sum of individual efforts"
    "🎯 Pragmatic|adj.|/præɡˈmætɪk/|Dealing with practical rather than idealistic considerations"
    "🔍 Meticulous|adj.|/məˈtɪkjələs/|Showing great attention to detail; very careful and precise"
    "💡 Innovation|noun|/ˌɪnəˈveɪʃən/|The introduction of new ideas, methods, or products"
    "🚀 Catalyst|noun|/ˈkætəlɪst/|Something that precipitates or accelerates change or action"
    "🎨 Aesthetic|noun|/ɛsˈθɛtɪk/|A set of principles concerned with beauty and artistic taste"
    "📊 Methodology|noun|/ˌmeθəˈdɒlədʒi/|A system of methods used in a particular field of study"
    "🔄 Iterative|adj.|/ˈɪtəreɪtɪv/|Involving repetition of a process to achieve desired results"
    "🎭 Eloquent|adj.|/ˈeləkwənt/|Fluent and persuasive in speaking or writing"
    "🏛️ Infrastructure|noun|/ˈɪnfrəstrʌktʃər/|The basic physical and organizational structures needed for operation"

    # Advanced Vocabulary
    "🌟 Serendipity|noun|/ˌserənˈdɪpəti/|The occurrence of fortunate events by chance"
    "🎯 Perspicacious|adj.|/ˌpɜːrspɪˈkeɪʃəs/|Having keen insight; mentally sharp and discerning"
    "🔍 Ubiquitous|adj.|/juˈbɪkwətəs/|Present, appearing, or found everywhere"
    "💫 Ephemeral|adj.|/ɪˈfemərəl/|Lasting for a very short time; transitory"
    "🎨 Aesthetic|adj.|/ɛsˈθɛtɪk/|Concerned with beauty or the appreciation of beauty"
    "🌊 Confluence|noun|/ˈkɒnfluəns/|A flowing together; the junction of two rivers or streams"
    "⚖️ Equanimity|noun|/ˌiːkwəˈnɪməti/|Mental calmness and composure, especially in difficult situations"
    "🎭 Nuanced|adj.|/ˈnuːɑːnst/|Characterized by subtle shades of expression or meaning"
    "🔮 Prescient|adj.|/ˈpresiənt/|Having knowledge of events before they take place"
    "🌅 Quintessential|adj.|/ˌkwɪntɪˈsenʃəl/|Representing the most perfect example of a quality"

    # Creative & Expressive Terms
    "🎨 Juxtaposition|noun|/ˌdʒʌkstəpəˈzɪʃən/|The fact of two things being placed close together for contrasting effect"
    "🌟 Luminous|adj.|/ˈluːmɪnəs/|Giving off light; bright or shining, especially in the dark"
    "🎵 Mellifluous|adj.|/meˈlɪfluəs/|Sweet or musical; pleasant to hear"
    "🌊 Undulating|adj.|/ˈʌndjʊleɪtɪŋ/|Moving with a smooth wavelike motion"
    "✨ Scintillating|adj.|/ˈsɪntɪleɪtɪŋ/|Sparkling or shining brightly; brilliantly and excitingly clever"
    "🏔️ Sublime|adj.|/səˈblaɪm/|Of such excellence or beauty as to inspire great admiration"
    "🌺 Resplendent|adj.|/rɪˈsplendənt/|Attractive and impressive through being richly colorful or sumptuous"
    "🎪 Whimsical|adj.|/ˈwɪmzɪkəl/|Playfully quaint or fanciful, especially in an appealing way"
    "🌙 Ethereal|adj.|/ɪˈθɪriəl/|Extremely delicate and light in a way that seems not of this world"
    "🎯 Incisive|adj.|/ɪnˈsaɪsɪv/|Intelligently analytical and clear-thinking"

    # Fintech & Financial Technology Terms
    "💰 Arbitrage|noun|/ˈɑːrbɪtrɑːʒ/|The practice of taking advantage of price differences in different markets"
    "🔗 Blockchain|noun|/ˈblɒktʃeɪn/|A distributed ledger technology that maintains a continuously growing list of records"
    "💳 Liquidity|noun|/lɪˈkwɪdəti/|The ease with which an asset can be converted into cash without affecting its market price"
    "📊 Volatility|noun|/ˌvɒləˈtɪləti/|The degree of variation in a trading price series over time"
    "🚀 Tokenization|noun|/ˈtoʊkənaɪˈzeɪʃən/|The process of converting rights to an asset into a digital token on a blockchain"
    "🔐 Cryptography|noun|/krɪpˈtɒɡrəfi/|The practice of securing communication through advanced mathematical algorithms"
    "💎 Decentralized|adj.|/diːˈsentrəlaɪzd/|Operating without a central authority or single point of control"
    "⚡ Algorithmic|adj.|/ˌælɡəˈrɪðmɪk/|Using mathematical algorithms to make trading or investment decisions"
    "🎯 Derivatives|noun|/dɪˈrɪvətɪvz/|Financial securities whose value is derived from an underlying asset"
    "💱 Forex|noun|/ˈfɔːreks/|The foreign exchange market where currencies are traded globally"
    "📈 Bull Market|noun|/bʊl ˈmɑːrkɪt/|A financial market characterized by rising prices and investor optimism"
    "📉 Bear Market|noun|/ber ˈmɑːrkɪt/|A financial market characterized by falling prices and investor pessimism"
    "🔄 DeFi|noun|/ˈdiːfaɪ/|Decentralized Finance - financial services built on blockchain technology"
    "💸 Yield|noun|/jiːld/|The income return on an investment, typically expressed as an annual percentage"
    "🏦 Fintech|noun|/ˈfɪntek/|Financial technology that aims to compete with traditional financial methods"
)

# Tip display mode (daily or random)
TIP_MODE="random"  # Can be "daily" or "random"
VOCAB_MODE="daily"  # Can be "daily" or "random"

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

# Toggle between daily and random vocab modes
random_vocab() {
    if [[ "$VOCAB_MODE" == "daily" ]]; then
        VOCAB_MODE="random"
        echo "🎲 Switched to random vocabulary! New terminals will show random words."
    else
        VOCAB_MODE="daily"
        echo "📅 Switched to daily vocabulary! New terminals will show daily words."
    fi
    show_vocab_of_day  # Show a vocab word immediately
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

show_vocab_of_day() {
    local day_seed vocab_index

    if [[ "$VOCAB_MODE" == "random" ]]; then
        # Use fetch_vocab to get a random word from the web API
        echo ""
        echo "🌐 Fetching random vocabulary from the web..."
        fetch_vocab
        return
    else
        # Use date as seed for consistent vocab per day (offset by 1 day from tips)
        day_seed=$(( $(date +%j) + 1 ))  # Day of year + 1 offset
        vocab_index=$((day_seed % ${#DAILY_VOCAB[@]}))

        # Parse vocabulary entry: "emoji Word|pos|pronunciation|definition"
        local vocab_entry="${DAILY_VOCAB[$vocab_index]}"
        local emoji_word="${vocab_entry%%|*}"
        local rest="${vocab_entry#*|}"
        local pos="${rest%%|*}"
        rest="${rest#*|}"
        local pronunciation="${rest%%|*}"
        local definition="${rest#*|}"

        # Define colors for vocabulary display
        local blue="\033[1;38;5;39m"    # Bright blue for headers
        local green="\033[1;38;5;46m"   # Bright green for word
        local yellow="\033[1;38;5;226m" # Bright yellow for pronunciation
        local cyan="\033[1;38;5;51m"    # Bright cyan for definition
        local reset="\033[0m"           # Reset color
        local mode_indicator="📚 Daily"

        echo ""
        echo -e "${blue}┌─ ${mode_indicator} Vocabulary ────────────────────────────────┐${reset}"
        echo -e "${blue}│${reset} ${green}${emoji_word}${reset} ${yellow}(${pos})${reset}"
        echo -e "${blue}│${reset} ${yellow}${pronunciation}${reset}"
        echo -e "${blue}│${reset} ${cyan}${definition}${reset}"
        echo -e "${blue}└─────────────────────────────────────────────────┘${reset}"
        echo -e "${blue}💡 Type 'random_vocab' to toggle daily/random • 'd word' to define${reset}"
        echo ""
    fi
}

# Function to show vocabulary on demand
vocab() {
    if [[ -n "$1" ]]; then
        # If argument provided, search for that word in our vocabulary list
        local search_term="$1"
        echo ""
        echo "🔍 Searching vocabulary for '$search_term':"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        local found=false
        for vocab_entry in "${DAILY_VOCAB[@]}"; do
            if [[ "${vocab_entry,,}" == *"${search_term,,}"* ]]; then
                local emoji_word="${vocab_entry%%|*}"
                local rest="${vocab_entry#*|}"
                local pos="${rest%%|*}"
                rest="${rest#*|}"
                local pronunciation="${rest%%|*}"
                local definition="${rest#*|}"

                echo "📚 ${emoji_word} (${pos})"
                echo "🔊 ${pronunciation}"
                echo "💡 ${definition}"
                echo ""
                found=true
            fi
        done

        if [[ "$found" == false ]]; then
            echo "❌ No vocabulary entries found for '$search_term'"
            echo "💡 Use 'vocab' alone to see today's word, or 'd $search_term' for dictionary lookup"
        fi
        echo ""
    else
        # No argument, show vocabulary of the day
        show_vocab_of_day
    fi
}

# Fetch new vocabulary from online APIs
fetch_vocab() {
    local word="$1"

    if [[ -z "$word" ]]; then
        # Get a random word first
        echo "🔍 Fetching random word..."
        word=$(curl -s "https://random-word-api.herokuapp.com/word" | jq -r '.[0]' 2>/dev/null)

        if [[ -z "$word" || "$word" == "null" ]]; then
            echo "❌ Could not fetch random word. Try providing a specific word: fetch_vocab <word>"
            return 1
        fi

        echo "🎯 Found word: $word"
    fi

    echo ""
    echo "📚 Fetching definition for '$word'..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Use Free Dictionary API (no API key required)
    local response=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/$word")

    if [[ "$response" == *"No Definitions Found"* ]]; then
        echo "❌ No definition found for '$word'"
        return 1
    fi

    # Parse the JSON response
    local word_text=$(echo "$response" | jq -r '.[0].word' 2>/dev/null)
    local phonetic=$(echo "$response" | jq -r '.[0].phonetic // empty' 2>/dev/null)
    local part_of_speech=$(echo "$response" | jq -r '.[0].meanings[0].partOfSpeech' 2>/dev/null)
    local definition=$(echo "$response" | jq -r '.[0].meanings[0].definitions[0].definition' 2>/dev/null)
    local example=$(echo "$response" | jq -r '.[0].meanings[0].definitions[0].example // empty' 2>/dev/null)

    # Display the vocabulary entry
    echo "📝 Word: $word_text"
    [[ -n "$phonetic" ]] && echo "🔊 Pronunciation: $phonetic"
    [[ -n "$part_of_speech" ]] && echo "📖 Part of Speech: $part_of_speech"
    [[ -n "$definition" ]] && echo "💡 Definition: $definition"
    [[ -n "$example" ]] && echo "💭 Example: $example"

    echo ""
    echo "💡 To add this to your vocabulary collection, add this line to DAILY_VOCAB:"
    local emoji="📝"  # Default emoji, could be made smarter based on word type
    echo "    \"$emoji $word_text|${part_of_speech:-noun}|${phonetic:-/word/}|$definition\""
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

# Enhanced command discovery function with man page info
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
    local commands_found=false
    for cmd in $(compgen -c | grep -i "$search_term" | sort -u | head -10); do
        echo "  • $cmd"
        commands_found=true
    done

    # Search in aliases
    echo ""
    echo " Your Aliases:"
    local aliases_found=false
    for alias_cmd in $(alias | grep -i "$search_term" | sed 's/alias \([^=]*\)=.*/\1/' | head -5); do
        echo "  • $alias_cmd"
        aliases_found=true
    done

    # Search in functions
    echo ""
    echo "⚙️  Your Functions:"
    local functions_found=false
    for func in $(declare -F | awk '{print $3}' | grep -i "$search_term" | head -5); do
        echo "  • $func"
        functions_found=true
    done

    # Search in brew packages
    if command -v brew &> /dev/null; then
        echo ""
        echo " Homebrew Packages:"
        local brew_found=false
        for pkg in $(brew list | grep -i "$search_term" | head -5); do
            echo "  • $pkg"
            brew_found=true
        done
    fi

    # Show man page information for the first matching command
    echo ""
    echo "📖 Man Page Information:"
    local first_cmd=$(compgen -c | grep -i "^$search_term" | head -1)
    if [[ -n "$first_cmd" ]] && command -v "$first_cmd" &>/dev/null; then
        echo "  📋 $first_cmd:"

        # Try whatis first (more reliable for descriptions)
        local whatis_desc=$(whatis "$first_cmd" 2>/dev/null | head -1)
        if [[ -n "$whatis_desc" ]]; then
            echo "     $whatis_desc"
        else
            # Fallback: try to extract from man page
            local man_desc=$(man "$first_cmd" 2>/dev/null | head -100 | grep -E "^[[:space:]]*[A-Z]" | head -1 | sed 's/^[[:space:]]*//')
            if [[ -n "$man_desc" ]]; then
                echo "     $man_desc"
            else
                echo "     (No man page description available)"
            fi
        fi

        # Show usage example
        echo "  💡 Usage: man $first_cmd"
    else
        echo "  (No matching command found for man page)"
    fi

    echo ""
    echo "💡 Use 'man <command>' for detailed documentation"
    echo " Use tab completion after typing '$search_term' to see more options"
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

# Set up enhanced completion for searching commands
complete -F _comprehensive_completion w q

# ==============================================================================
# ENHANCED HISTORY SHARING
# ==============================================================================

# Enable history sharing across terminals
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and commands starting with space
export HISTTIMEFORMAT="%Y-%m-%d %T "     # Add timestamps to history

# Enhanced history sharing with error handling
enhanced_history_share() {
    # Only run if we're in an interactive shell
    [[ $- == *i* ]] || return

    # Append current session to history file
    history -a 2>/dev/null

    # Clear current session history (prevents duplicates)
    history -c 2>/dev/null

    # Read from history file
    history -r 2>/dev/null
}

# Add to existing PROMPT_COMMAND (preserve existing)
if [[ -n "$PROMPT_COMMAND" ]]; then
    # Check if enhanced_history_share is already in PROMPT_COMMAND
    if [[ "$PROMPT_COMMAND" != *"enhanced_history_share"* ]]; then
        export PROMPT_COMMAND="$PROMPT_COMMAND; enhanced_history_share"
    fi
else
    export PROMPT_COMMAND="enhanced_history_share"
fi

# History search shortcuts
alias hist='history'
alias hg='history | grep'
alias hc='history -c'  # Clear history
alias hs='history | tail -20'  # Show last 20 commands

# Better history search
bind '"\e[A": history-search-backward'   # Up arrow searches history
bind '"\e[B": history-search-forward'    # Down arrow searches history

# Search history with fzf (if available)
if command -v fzf &> /dev/null; then
    # Unified fzf history search function
    __fzf_history__() {
        local cmd
        cmd=$(history | fzf --tac --tiebreak=index --height=40% --border --prompt="Search History: " | sed 's/^\s*[0-9]\+\s*//')
        if [[ -n "$cmd" ]]; then
            READLINE_LINE="$cmd"
            READLINE_POINT=${#cmd}
        fi
    }

    # Function to trigger fzf history search from command line
    fzf_history_search() {
        local selected_cmd
        selected_cmd=$(history | fzf --tac --tiebreak=index --height=40% --border --prompt="Search History: " | sed 's/^\s*[0-9]\+\s*//')
        if [[ -n "$selected_cmd" ]]; then
            echo "$selected_cmd"
        fi
    }

    # Keyboard shortcuts
    bind '"\C-r": "\C-x1\e^\er"'      # Ctrl+R with fzf
    bind -x '"\C-x1": __fzf_history__'
    bind '"\eh": "h\n"'                # Alt+H to trigger 'h' command

    # Alias 'h' to trigger fzf history search
    alias h='fzf_history_search'
else
    # Fallback: if fzf not available, show regular history
    alias h='history'
fi

# Show what every letter of the alphabet does
alphabet_commands() {
    echo ""
    echo "🔤 Alphabet Commands"
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
            cmd_info="→"
        fi

        printf "%-3s %s\n" "$letter:" "$cmd_info"
    done

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Use 'alias', 'declare -F', or 'type <command>' for more details"
    echo ""
}
alias a=alphabet_commands

# Show tip when starting new shell (not in subshells)
if [[ -z "$BASH_SUBSHELL" || "$BASH_SUBSHELL" == "0" ]]; then
    show_tip_of_day
    # show_vocab_of_day
    a
fi
