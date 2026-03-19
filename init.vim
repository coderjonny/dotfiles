set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source
endif

" Plugins will be downloaded under the specified directory.
" And Declare the list of plugins.
call plug#begin('~/.vim/plugged')

  Plug 'neoclide/coc.nvim', {'branch': 'release'} "Intellisense engine for vim8 & neovim, full language server protocol support as VSCode

  Plug '/opt/homebrew/opt/fzf' " fzf fuzzy finder
  Plug 'JamshedVesuna/vim-markdown-preview' " markdown previewer
  Plug 'Yggdroot/indentLine' "Indent lines
  Plug 'airblade/vim-rooter' "Changes Vim working directory to project root.
  Plug 'bling/vim-bufferline' " vim-bufferline
  Plug 'chrisbra/Colorizer' " Highlight HEX/RGB color codes/names
  " Plug 'ctrlpvim/ctrlp.vim' " ctrlP - REMOVED: redundant with fzf
  Plug 'dense-analysis/ale' " ale
  Plug 'easymotion/vim-easymotion' " vim-easymotion
  Plug 'embear/vim-localvimrc' " vim-localvimrc
  " Plug 'flowtype/vim-flow' " vim-flow - REMOVED: CoC handles this
  Plug 'itchyny/lightline.vim' " Lightline status-line
  Plug 'jlanzarotta/bufexplorer' " bufexplorer
  Plug 'jremmen/vim-ripgrep' " vim-ripgrep
  Plug 'junegunn/goyo.vim' " goyo.vim
  Plug 'junegunn/seoul256.vim' " seoul256 colors
  Plug 'junegunn/vim-easy-align' " vim-easy-align
  Plug 'junegunn/fzf.vim' "fzf addons
  Plug 'justinmk/vim-sneak' " Jump to any location specified by two characters
  Plug 'liuchengxu/vim-clap' "👏 Modern generic interactive finder and dispatcher for Vim and NeoVim
  Plug 'liuchengxu/vista.vim' "🌵 Viewer & Finder for LSP symbols and tags http://liuchengxu.org/vista.vim
  Plug 'mattn/emmet-vim' " emmet-vim
  Plug 'maximbaz/lightline-ale' "Ale indicator for the lightline vim plugin
  " Plug 'mhinz/vim-signify' " REMOVED: replaced by gitsigns.nvim (more features, GitLens-like)
  Plug 'nvim-lua/plenary.nvim' " Required dependency for gitsigns and diffview
  Plug 'lewis6991/gitsigns.nvim' " Git signs + inline blame (GitLens-like)
  Plug 'sindrets/diffview.nvim' " Git diff viewer and file history
  Plug 'mhinz/vim-startify' " vim-startify
  Plug 'ntpeters/vim-better-whitespace' " Vim Better Whitespace Plugin
  Plug 'scrooloose/nerdcommenter' " nerdcommenter
  Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin' " nerdtree & nerdtree-git-plugin
"  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'terryma/vim-expand-region' " vim-expand-region
  " Plug 'terryma/vim-multiple-cursors' " REMOVED: deprecated, use mg979/vim-visual-multi
  Plug 'tpope/vim-commentary' " vim-commentary
  Plug 'tpope/vim-fugitive' " vim-fugitive
  Plug 'tpope/vim-sensible' " vim-sensible
  Plug 'tpope/vim-surround' " vim-surround
  " Plug 'wokalski/autocomplete-flow' " REMOVED: outdated deoplete plugin, CoC handles this
  " Plug 'ggml-org/llama.vim' "Vim plugin for LLM-assisted code/text completion
  " Plug 'ryanoasis/vim-devicons' " adds file type icons to Vim  plugins such as NERDtree, ctrlp, lightline ..etc
  "
  " 2026 new plugins
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' } "markdown
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'} "parser for syntax highlight
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'NLKNguyen/papercolor-theme' " PaperColor - high contrast light/dark theme
  Plug 'ActivityWatch/aw-watcher-vim'


call plug#end()

source ~/.vimrc
