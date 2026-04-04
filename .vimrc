" ===================================
" .vimrc - Modular Config Loader
" ===================================
" Run :checkhealth after changes to validate
"
" how to benchmark startup time with --startuptime
" - nvim -O ~/.bash_profile ~/.vimrc.after --startuptime vim.log

source ~/.dotfiles/vimrc/settings.vim
source ~/.dotfiles/vimrc/colors.vim
source ~/.dotfiles/vimrc/plugins.vim
source ~/.dotfiles/vimrc/keymaps.vim
source ~/.dotfiles/vimrc/lua-configs.vim
