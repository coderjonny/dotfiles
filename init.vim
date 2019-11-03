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

" nerdtree & nerdtree-git-plugin
  Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
" vim-easy-align
  Plug 'junegunn/vim-easy-align'
" ale
  Plug 'dense-analysis/ale'
" bufexplorer
  Plug 'jlanzarotta/bufexplorer'
" fzf fuzzy finder
  Plug '/usr/local/opt/fzf'
" ctrlP
  Plug 'ctrlpvim/ctrlp.vim'
" emmet-vim
  Plug 'mattn/emmet-vim'
" vim-airline
" Plug 'vim-airline/vim-airline'
" lightline
  Plug 'itchyny/lightline.vim'
" vim-bufferline
  Plug 'bling/vim-bufferline'
" vim-localvimrc
  Plug 'embear/vim-localvimrc'
" vim-sensible
  Plug 'tpope/vim-sensible'
" vim-flow
  Plug 'flowtype/vim-flow'
" vim-ripgrep
  Plug 'jremmen/vim-ripgrep'
" nerdcommenter
  Plug 'scrooloose/nerdcommenter'
" deoplete
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'roxma/nvim-yarp'
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
" For func argument completion
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'ntpeters/vim-better-whitespace'
" plugins for deocomplete
  Plug 'wokalski/autocomplete-flow'
" vim-surround
  Plug 'tpope/vim-surround'
" vim-fugitive
  Plug 'tpope/vim-fugitive'
" vim-colorschemes
" Plug 'flazz/vim-colorschemes'
" seoul256 colors
  Plug 'junegunn/seoul256.vim'
" vim-easymotion
  Plug 'easymotion/vim-easymotion'
" Highlight HEX and RGB color codes and names in their background
  Plug 'chrisbra/Colorizer'
" Jump to any location specified by two characters
  Plug 'justinmk/vim-sneak'
" vim-startify
  Plug 'mhinz/vim-startify'
" vim-multiple-cursors
  Plug 'terryma/vim-multiple-cursors'
" goyo.vim
  Plug 'junegunn/goyo.vim'

call plug#end()

source ~/.vimrc
