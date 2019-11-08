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

  Plug '/usr/local/opt/fzf' " fzf fuzzy finder
  Plug 'JamshedVesuna/vim-markdown-preview' " markdown previewer
  Plug 'Yggdroot/indentLine' "Indent lines
  Plug 'airblade/vim-rooter' "Changes Vim working directory to project root.
  Plug 'bling/vim-bufferline' " vim-bufferline
  Plug 'chrisbra/Colorizer' " Highlight HEX/RGB color codes/names
  Plug 'ctrlpvim/ctrlp.vim' " ctrlP
  Plug 'dense-analysis/ale' " ale
  Plug 'easymotion/vim-easymotion' " vim-easymotion
  Plug 'embear/vim-localvimrc' " vim-localvimrc
  Plug 'flowtype/vim-flow' " vim-flow
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
  Plug 'mhinz/vim-signify' " Signify (or just Sy) uses the sign column to indicate added, modified and removed lines in a file that is managed by a version control system (VCS).
  Plug 'mhinz/vim-startify' " vim-startify
  Plug 'neoclide/coc.nvim', {'branch': 'release'} "Intellisense engine for vim8 & neovim, full language server protocol support as VSCode
  Plug 'ntpeters/vim-better-whitespace' " Vim Better Whitespace Plugin
  Plug 'scrooloose/nerdcommenter' " nerdcommenter
  Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin' " nerdtree & nerdtree-git-plugin
  Plug 'terryma/vim-expand-region' " vim-expand-region
  Plug 'terryma/vim-multiple-cursors' " vim-multiple-cursors
  Plug 'tpope/vim-commentary' " vim-commentary
  Plug 'tpope/vim-fugitive' " vim-fugitive
  Plug 'tpope/vim-sensible' " vim-sensible
  Plug 'tpope/vim-surround' " vim-surround
  Plug 'wokalski/autocomplete-flow' " plugins for deocomplete

  " Plug 'ryanoasis/vim-devicons' " adds file type icons to Vim  plugins such as NERDtree, ctrlp, lightline ..etc

  " " deoplete
  " if has('nvim')
  "   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " else
  "   Plug 'Shougo/deoplete.nvim'
  "   Plug 'roxma/nvim-yarp'
  "   Plug 'roxma/vim-hug-neovim-rpc'
  " endif
  " " For func argument completion
  " Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'


call plug#end()

source ~/.vimrc
