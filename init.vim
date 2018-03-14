set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
" ale
Plug 'w0rp/ale'
" bufexplorer
Plug 'jlanzarotta/bufexplorer'
" emmet-vim
Plug 'mattn/emmet-vim'
" nerdtree & nerdtree-git-plugin
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'ryanoasis/vim-devicons'

" vim-airline
Plug 'vim-airline/vim-airline'
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
" deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" plugins for deocomplete
Plug 'wokalski/autocomplete-flow'
" For func argument completion
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" vim-startify
Plug 'mhinz/vim-startify'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
