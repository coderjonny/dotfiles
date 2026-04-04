" ===================================
" Editor Settings
" ===================================

" if hidden is not set, TextEdit might fail.
  set hidden

" Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

" Better display for messages
  set cmdheight=2

  set updatetime=2000

" don't give |ins-completion-menu| messages.
  set shortmess+=c

" always show signcolumns
  set signcolumn=yes

"" Whitespaces, tabs, spaces
  set nowrap           " Don't wrap lines
  set linebreak        " Wrap lines at convenient points
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab
  set list listchars=tab:\ \ ,trail:·

  set scrolloff=5 " Keep 5 lines below and above the cursor

  set noswapfile
  set number
  set ruler

" Searching
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase

" Status bar
  set laststatus=2

  autocmd FocusLost * silent! wa " Automatically save file

  " use per-project .vimrc files
  set exrc
  set secure

  set nospell " turn off spellcheck
  " set spell spelllang=en_us " underline incorrect spelling
  " Only enable spell check for non-code files"
  " autocmd FileType markdown,text,gitcommit setlocal spell spelllang=en_us

  " autocmd FileType html :setlocal sw=2 ts=2 sts=2 " Two spaces for HTML files "

  " load the plugin and indent settings for the detected filetype
  filetype plugin indent on

"" Tab completion
  set wildmode=list:longest,list:full
  set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

"" allow backspacing over everything in insert mode
  set backspace=indent,eol,start

" Use modeline overrides
  set modeline
  set modelines=10


" Show (partial) command in the status line
  set showcmd

" Remember last location in file
  if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal g'\"" | endif
  endif

  function s:setupWrapping()
      set wrap
      set wrapmargin=2
      set textwidth=80
  endfunction

  function s:setupMarkup()
      call s:setupWrapping()
  endfunction

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru,Podfile}    set ft=ruby
" md, markdown, and mk are markdown and define buffer-local preview
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
  au BufRead,BufNewFile *.txt call s:setupWrapping()

  set clipboard=unnamedplus
