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
# PROMPT SETUP
# ==============================================================================

# Colors optimized for light mode terminals with emoji-inspired palette
NO_COLOR="\[\033[0m\]"
FOREST_GREEN="\[\033[38;5;22m\]"    # 🐸🐢🐍 inspired - dark green, readable in light mode
OCEAN_BLUE="\[\033[38;5;26m\]"      # 🐧🐠🐳🐬 inspired - deep blue
TIGER_ORANGE="\[\033[38;5;208m\]"   # 🐯🐥 inspired - vibrant orange  
BEAR_BROWN="\[\033[38;5;94m\]"      # 🐶🐺🐻🐵 inspired - rich brown
CHERRY_RED="\[\033[38;5;160m\]"     # Error state - deep red
PURPLE="\[\033[38;5;93m\]"          # Git branches - royal purple

# Mood indicator based on last command exit status (with fun colors!)
print_mood() {
    if [ $? -eq 0 ]; then
        # Success - happy animals in ocean blue
        printf "%s\n" "$OCEAN_BLUE ^.^ $NO_COLOR"
    else
        # Error - distressed in cherry red  
        printf "%s\n" "$CHERRY_RED O.O $NO_COLOR"
    fi
}

# Git branch in prompt with better visibility
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Emoji collections grouped by color families
brown_animals=(🐶 🐺 🐻 🐵 🦊)           # Brown/tan creatures
gray_animals=(🐭 🐹 🐰 🐨 🐼 🐧)         # Gray/white creatures  
colorful_animals=( 🐸 🐷 🐮)        # Vibrant multicolored
ocean_animals=(🐙 🐠 🐳 🐬)              # Blue ocean life
golden_animals=(🐥 🐱 🐯)                      # Golden/yellow

# Color groups to match emoji families
emoji_groups=(
    "brown_animals[@]:$BEAR_BROWN"
    "gray_animals[@]:$NO_COLOR"
    "colorful_animals[@]:$TIGER_ORANGE" 
    "ocean_animals[@]:$OCEAN_BLUE"
    "golden_animals[@]:$TIGER_ORANGE"
)

# Function to get random colored emoji and matching color (compatible with older bash)
get_colored_emoji_and_path_color() {
    # Safety check for empty emoji_groups array
    if [ ${#emoji_groups[@]} -eq 0 ]; then
        printf "🐶:$TIGER_ORANGE"
        return
    fi
    
    local group_data="${emoji_groups[$RANDOM % ${#emoji_groups[@]}]}"
    local emoji_array="${group_data%:*}"
    local color="${group_data#*:}"
    
    # Use eval for indirect array access (compatible with older bash)
    local emoji_list
    eval "emoji_list=(\"\${${emoji_array}}\")"
    
    # Safety check for empty emoji list
    if [ ${#emoji_list[@]} -eq 0 ]; then
        printf "🐶:$TIGER_ORANGE"
        return
    fi
    
    local emoji="${emoji_list[$RANDOM % ${#emoji_list[@]}]}"
    
    # Return both emoji with color and the color for path coordination
    printf "%s%s%s:%s" "$color" "$emoji" "$NO_COLOR" "$color"
}

# Enhanced prompt with color-coordinated emoji and path
set_bash_prompt() {
    local emoji_and_color="$(get_colored_emoji_and_path_color)"
    local colored_emoji="${emoji_and_color%:*}"
    local path_color="${emoji_and_color#*:}"
    
    PS1="$(print_mood)${path_color}\w$PURPLE\$(parse_git_branch)$NO_COLOR $colored_emoji $FOREST_GREEN->$NO_COLOR "
}
PROMPT_COMMAND=set_bash_prompt

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
