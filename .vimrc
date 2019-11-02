" ===================================
" Jonny's vimrc :)
"
" ===================================

" ======= NOTES =======
"
" how to benchmark startup time with --startuptime
" - nvim -O ~/.bash_profile ~/.vimrc.after --startuptime vim.log
" - vim -O ~/.bash_profile ~/.vimrc.after --startuptime vim.log
"

" Automatically install missing plugins on startup
  if has('nvim')
      autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
  endif


" ===================================
" Plugin configurations
" ===================================

" NERDTree configuration
  let NERDTreeIgnore                    = ['\.pyc$', '\.rbc$', '\~$']
  " close vim if the only window left open is NERDTree
  autocmd bufenter * if (winnr("$")    == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " open up nerdTree whenever vim opens
  autocmd vimenter * NERDTree
  " opening directory
  autocmd StdinReadPre * let s:std_in   = 1
  autocmd VimEnter * if argc()         == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  " show dotfiles
  let NERDTreeShowHidden                = 1
  " Automatically delete the buffer of the file you just deleted with NerdTree:
  let NERDTreeAutoDeleteBuffer          = 1

" ALE <3 ( async linter for es6, flow, js, swift, etc.. )
  " fix lint errors
  let g:ale_fixers                      = { 'javascript': ['eslint'] }
  " fix automatically on save
  let g:ale_fix_on_save                 = 1
  " Enable completion where available.
  let g:ale_completion_enabled          = 1
  " customize signs
  let g:ale_sign_error                  = '☃️'
  let g:ale_sign_warning                = '❄️'
  " display ale in Airline
  let g:airline#extensions#ale#enabled  = 1

" vim-airline - sexier statusline
  let g:airline_powerline_fonts         = 1
  let g:airline_section_c               = '%F'

" vim-flow - jump to flow errors
  " fucking close that window
  let g:flow#autoclose                  = 1
  " and don't even show it cuz I'm using ale
  let g:flow#showquickfix               = 0
  " jump to that error
  let g:flow#errjmp                     = 1
  "Use locally installed flow
  let local_flow                        = finddir('node_modules', '.;') . '/.bin/flow'
  if matchstr(local_flow, "^\/\\w")    == ''
      let local_flow                    = getcwd() . "/" . local_flow
  endif
  if executable(local_flow)
    let g:flow#flowpath                 = local_flow
  endif

" rip-grep - in vim
  let g:rg_highlight = 1

" deocomplete
  let g:deoplete#enable_at_startup = 1

" nerdcommenter
  " Add spaces after comment delimiters by default
  let g:NERDSpaceDelims = 1
  " Use compact syntax for prettified multi-line comments
  let g:NERDCompactSexyComs = 1
  " Align line-wise comment delimiters flush left instead of following code indentation
  let g:NERDDefaultAlign = 'left'
  " Set a language to use its alternate delimiters by default
  let g:NERDAltDelims_java = 1
  " Add your own custom formats or override the defaults
  let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
  " Allow commenting and inverting empty lines (useful when commenting a region)
  let g:NERDCommentEmptyLines = 1
  " Enable trimming of trailing whitespace when uncommenting
  let g:NERDTrimTrailingWhitespace = 1
  " Enable NERDCommenterToggle to check all selected lines is commented or not 
  let g:NERDToggleCheckAllLines = 1


"           _   _   _
"  ___  ___| |_| |_(_)_ __   __ _ ___
" / __|/ _ \ __| __| | '_ \ / _` / __|
" \__ \  __/ |_| |_| | | | | (_| \__ \
" |___/\___|\__|\__|_|_| |_|\__, |___/
"                         |___/
""""""""""""""""""""""""""""""""""""""
" Make the cursor blink
  :set guicursor=a:blinkon500

"  _ __ ___ _ __ ___   __ _ _ __  ___
" | '__/ _ \ '_ ` _ \ / _` | '_ \/ __|
" | | |  __/ | | | | | (_| | |_) \__ \
" |_|  \___|_| |_| |_|\__,_| .__/|___/
"                          |_|
""""""""""""""""""""""""""""""""""""""

" Toggle nerdtree with leader key + n
  map <Leader>n :NERDTreeToggle<CR>

" escape out of i mode
  inoremap jj <ESC>

" BufExplorer - quickkly change buffers
  " make tab open BufExplorer
  nnoremap <tab> :BufExplorer<CR>

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)

" (shift + control + f) to search files with rg
  nmap <c-s-f> :Rg<space>


"" neosnippet
"    let g:neosnippet#enable_completed_snippet = 1
"

"" vim-better-whitespace
"    let g:better_whitespace_enabled=1
"    let g:strip_whitespace_on_save=1
"
"" startify
let g:startify_change_to_dir = 1
let g:startify_session_before_save = [
        \ 'echo "Cleaning up before saving.."',
        \ 'silent! NERDTreeTabsClose'
        \ ]









"" Command-T configuration
"    let g:CommandTMaxHeight=20
"
"" CTags
"    map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
"    map <C-\> :tnext<CR>
"
"" Gundo configuration
"    nmap <F5> :GundoToggle<CR>
"    imap <F5> <ESC>:GundoToggle<CR>
"" set working dir to open file
"autocmd BufEnter * lcd %:p:h
"
"
"" ==========================
"" extra rules and mappings
"" ==========================
"
"let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
"set nocompatible
"set noswapfile
"set number
"set ruler
"syntax on
"
"" Map <leader> key to comma key too
":nmap , <Leader>
":vmap , <Leader>
"
""shut the fuck up
"set vb
"
"" Set encoding
"set encoding=utf8
"" set guifont=DroidSansMono_Nerd_Font:h11
"
"" Whitespaces, tabs, spaces
"set nowrap           " Don't wrap lines
"set linebreak        " Wrap lines at convenient points
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
"set expandtab
"set list listchars=tab:\ \ ,trail:·
"
"set scrolloff=5 " Keep 5 lines below and above the cursor
"set cursorline
"
"autocmd FocusLost * silent! wa " Automatically save file
"
"" use per-project .vimrc files
"set exrc
"set secure
"
"" autocmd FileType html :setlocal sw=2 ts=2 sts=2 " Two spaces for HTML files "
"
"" load the plugin and indent settings for the detected filetype
"filetype plugin indent on
"
"" Searching
"set hlsearch
"set incsearch
"set ignorecase
"set smartcase
"
"" Tab completion
"set wildmode=list:longest,list:full
"set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
"
"" Status bar
"set laststatus=2
"
"" Remember last location in file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
"    \| exe "normal g'\"" | endif
"endif
"
"function s:setupWrapping()
"    set wrap
"    set wrapmargin=2
"    set textwidth=72
"endfunction
"
"function s:setupMarkup()
"    call s:setupWrapping()
"    map <buffer> <Leader>p :Hammer<CR>
"endfunction
"
"" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
"" au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby
"
"" md, markdown, and mk are markdown and define buffer-local preview
"au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
"au BufRead,BufNewFile *.txt call s:setupWrapping()
"
"" allow backspacing over everything in insert mode
"set backspace=indent,eol,start
"
"" ==========================
"" Bubbling configuration using unimpaired mapping
"" ==========================
"" Bubble single lines UP and DOWN
"nmap <C-k> [e
"nmap <C-j> ]e
"" Bubble multiple lines with j & k
"vmap <C-k> [egv
"vmap <C-j> ]egv
"
"" Bubble left and right with h & l
"nmap <C-l> >>
"nmap <C-h> <<
"" Bubble multiple lines
"vmap <C-l> > gv
"vmap <C-h> < gv
"
"" unindent in insert mode with shift-tab
"inoremap <S-Tab> <C-D>
"
"" Opens an edit command with the path of the currently edited file filled in
"" Normal mode: <Leader>e
"map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
"
"" Opens a tab edit command with the path of the currently edited file filled in
"" Normal mode: <Leader>t
"map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>
"
"" Inserts the path of the currently edited file into a command
"" Command mode: Ctrl+P
"cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
"
"" gist-vim defaults
"if has("mac")
"  let g:gist_clip_command = 'pbcopy'
"elseif has("unix")
"  let g:gist_clip_command = 'xclip -selection clipboard'
"endif
"let g:gist_detect_filetype = 1
"let g:gist_open_browser_after_post = 1
"
"" Use modeline overrides
"set modeline
"set modelines=10
"
"" Default color scheme
"" color solarized
"set background=dark
"
" "Turn on jslint errors by default
"let g:JSLintHighlightErrorLine = 1
"
"" MacVIM shift+arrow-keys behavior (required in .vimrc)
"let macvim_hig_shift_movement = 1
"
"" % to bounce from do to end etc.
"runtime! macros/matchit.vim
"
"" Show (partial) command in the status line
"set showcmd
"
"" Include user's local vim config
"if filereadable(expand("~/.vimrc.local"))
"source ~/.vimrc.local
"endif
"
"" shift + control + t reopens last closed window
"nmap <c-s-t> :vs<bar>:b#<CR>
"
"" Shift tab will open current window in a new tab
"nnoremap <S-tab> :tab split<CR>
"" then ZZ to close out
"" or
"" c-w-| to have window take over (if using vsplits).
"" c-w-= to restore.
"" c-w-_ for horizontal splits
"
"" shows RELATIVENUMBER on side rail
"" set relativenumber
"" but set other windows to default
"" augroup numbertoggle
"  " autocmd!
"  " autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  " autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"" augroup END
"
""space bar unhighlights search
"nmap <space> :noh<CR>
"
"" Gif config
"map  / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)
"
"" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
"" Without these mappings, `n` & `N` works fine. (These mappings just provide
"" different highlight method and have some other features )
"map  n <Plug>(easymotion-next)
"map  N <Plug>(easymotion-prev)
"
""Turning off Gdiff off while multiple windows are open
""" Simple way to turn off Gdiff splitscreen
"" works only when diff buffer is focused
"if !exists(":Gdiffoff")
"  command Gdiffoff diffoff | q | Gedit
"endif
"
"" make ctrlP load 100x faster
"let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
"
"" for git-gutter file change refresh
"set updatetime=100
"
"nmap <Leader>b :Gblame<CR>
"
"" type 'QQ' to save and quit out of vim quickly
""
"map QQ :conf xa<CR>
"map Q :conf q<CR>
