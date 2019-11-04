"
" ===================================

" ======= NOTES =======
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
  " opening directory
  autocmd StdinReadPre * let s:std_in   = 1
  autocmd VimEnter * if argc()         == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  " show dotfiles
  let NERDTreeShowHidden                = 1
  " Automatically delete the buffer of the file you just deleted with NerdTree:
  let NERDTreeAutoDeleteBuffer          = 1

" ALE <3 ( async linter for es6, flow, js, swift, etc.. ) syntax highlighting and fixing linting
  nmap <C-a> :ALENext<CR>
  nmap <C-x> :ALEDetail<CR>
  let g:ale_sign_column_always = 1 " sign gutter always open
  let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['eslint'],
    \   'typescript': ['prettier', 'eslint']
    \}
  let g:ale_linter_aliases = {'tsx': ['css', 'ale-javascript-eslint']}
  let g:ale_linters = {'tsx': ['stylelint', 'ale-javascript-eslint']}
  " Fix automatically on save
  let g:ale_fix_on_save                 = 1
  " Enable completion where available.
  let g:ale_completion_enabled          = 1
  " Customize signs
  let g:ale_sign_error                  = '🍂'
  let g:ale_sign_warning                = '🍃'
" Make sure typescript files are set as tsx files
  augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.tsx set filetype=typescript.tsx
  augroup END

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
  let g:rg_highlight                    = 1

" deocomplete
  let g:deoplete#enable_at_startup      = 1
  " Enable completion where available.
  " This setting must be set before ALE is loaded.
  "
  " You should not turn this setting on if you wish to use ALE as a completion
  " source for other completion plugins, like Deoplete.
  let g:ale_completion_enabled = 1
  let g:ale_completion_tsserver_autoimport = 1

" nerdcommenter
  " Add spaces after comment delimiters by default
  let g:NERDSpaceDelims                 = 1
  " Use compact syntax for prettified multi-line comments
  let g:NERDCompactSexyComs             = 1
  " Align line-wise comment delimiters flush left instead of following code indentation
  let g:NERDDefaultAlign                = 'left'
  " Set a language to use its alternate delimiters by default
  let g:NERDAltDelims_java              = 1
  " Add your own custom formats or override the defaults
  let g:NERDCustomDelimiters            = { 'c': { 'left': '/**','right': '*/' } }
  " Allow commenting and inverting empty lines (useful when commenting a region)
  let g:NERDCommentEmptyLines           = 1
  " Enable trimming of trailing whitespace when uncommenting
  let g:NERDTrimTrailingWhitespace      = 1
  " Enable NERDCommenterToggle to check all selected lines is commented or not
  let g:NERDToggleCheckAllLines         = 1

" git-gutter
  let g:gitgutter_sign_allow_clobber = 1
" git diff toggle with (g + d keys)
  map gd :GitGutterLineHighlightsToggle<CR>
  nmap ]c <Plug>GitGutterNextHunk
  nmap [c <Plug>GitGutterPrevHunk
  nmap <Leader>hs <Plug>(GitGutterStageHunk)
  nmap <Leader>hu <Plug>(GitGutterUndoHunk)

" startify
  nmap <C-s> :Startify<CR>
  autocmd User Startified setlocal cursorline
  let g:startify_change_to_dir = 1
  let g:startify_session_before_save = [
      \ 'echo "Cleaning up before saving.."',
      \ 'silent! NERDTreeTabsClose'
      \ ]
  autocmd VimEnter *
      \   if !argc()
      \ |   Startify
      \ |   NERDTree
      \ |   wincmd w
      \ | endif
  let g:startify_bookmarks = [
      \ { 'v': '~/.vimrc' },
      \ { 'b': '~/.bash_profile' },
      \ { 'i': '~/.config/nvim/init.vim' },
      \ ]

" vim-better-whitespace
  let g:better_whitespace_enabled=1
  let g:strip_whitespace_on_save=1

" lightline
  set noshowmode " (remove redunant mode info)
  function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : 'warnings: ' . all_non_errors . ', errors:' . all_errors

    " printf(
    "       \   '%dW %dE',
    "       \   all_non_errors,
    "       \   all_errors
    "       \)
  endfunction
  let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'linter': 'LinterStatus'
      \ },
      \ }
  let g:lightline.active = {
        \  'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]],
        \  'left': [[ 'mode', 'paste' ],
        \           [ 'gitbranch', 'readonly', 'filename', 'modified' ],
        \           [ 'linter']]
        \  }
  let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
  let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

" markdown
  let vim_markdown_preview_hotkey='<C-m>'
  let vim_markdown_preview_github=1
  let vim_markdown_preview_browser='Google Chrome'

" Goyo
  nmap <C-g> :Goyo<CR>

" CtrlP load faster and ignore files in .gitignore
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']


"           _   _   _
"  ___  ___| |_| |_(_)_ __   __ _ ___
" / __|/ _ \ __| __| | '_ \ / _` / __|
" \__ \  __/ |_| |_| | | | | (_| \__ \
" |___/\___|\__|\__|_|_| |_|\__, |___/
"                         |___/
""""""""""""""""""""""""""""""""""""""
" updateTime: default = 4000(ms) = (4 seconds) no good for async update
  set updatetime=80

" Make the cursor blink
  set guicursor=a:blinkon100

"" Whitespaces, tabs, spaces
  set nowrap           " Don't wrap lines
  set linebreak        " Wrap lines at convenient points
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab
  set list listchars=tab:\ \ ,trail:·

  set scrolloff=5 " Keep 5 lines below and above the cursor
  set cursorline

  set noswapfile
  set number
  set ruler
  syntax on

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

	set spell spelllang=en_us " underline incorrect spelling

  " autocmd FileType html :setlocal sw=2 ts=2 sts=2 " Two spaces for HTML files "

  " load the plugin and indent settings for the detected filetype
  filetype plugin indent on
  filetype plugin on

"" Tab completion
  set wildmode=list:longest,list:full
  set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

"" allow backspacing over everything in insert mode
  set backspace=indent,eol,start

" Use modeline overrides
  set modeline
  set modelines=10

"" Default color scheme
  colo seoul256
  set background=dark
  set termguicolors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Show (partial) command in the status line
  set showcmd

" but set other windows to default
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END

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
      map <buffer> <Leader>p :Hammer<CR>
  endfunction

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru,Podfile}    set ft=ruby
" md, markdown, and mk are markdown and define buffer-local preview
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
  au BufRead,BufNewFile *.txt call s:setupWrapping()




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
" control + t: ctrlT pops up FZF
  let $FZF_DEFAULT_COMMAND = 'rg --hidden -l ""'
  map <c-t> :FZF<CR>
" Saving sessions to F2 and F3
  map <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
  map <F3> :source ~/vim_session <cr>     " And load session with F3

  function s:load_session()
    :source ~/vim_session <cr>
  endfunction

  function s:save_session()
    :mksession! ~/vim_session <cr>
  endfunction

  function s:before_quit()
    call s:save_session()
    :conf xa<CR>
  endfunction

" type 'QQ' to save and quit out of vim quickly
  map QQ :conf xa<CR>
  map Q :conf q<CR>

" Map <leader> key to comma key too
  :nmap , <Leader>
  :vmap , <Leader>

" ==========================
" Bubbling 🧼
" ==========================
" Bubble single lines UP and DOWN
  nnoremap <silent> <C-c>  @='"zyy"zp'<CR>
  vnoremap <silent> <C-c>  @='"zy"zPgv'<CR>
  nnoremap <silent> <C-j>  @='"zdd"zp'<CR>
  vnoremap <silent> <C-j>  @='"zx"zp`[V`]'<CR>
  nnoremap <silent> <C-k>  @='k"zdd"zpk'<CR>
  vnoremap <silent> <C-k>  @='"zxk"zP`[V`]'<CR>
" Bubble left and right with h & l
  nmap <C-l> >>
  nmap <C-h> <<
" Bubble multiple lines
  vmap <C-l> > gv
  vmap <C-h> < gv

" unindent in insert mode with shift-tab
  inoremap <S-Tab> <C-D>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
  map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
  map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" gist-vim defaults
  if has("mac")
    let g:gist_clip_command = 'pbcopy'
  elseif has("unix")
    let g:gist_clip_command = 'xclip -selection clipboard'
  endif
  let g:gist_detect_filetype = 1
  let g:gist_open_browser_after_post = 1

" space bar undo highlights search in normal mode
  nmap <space> :noh<CR>

"  Gif config
  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)

"  These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
"  Without these mappings, `n` & `N` works fine. (These mappings just provide
"  different highlight method and have some other features )
  map  n <Plug>(easymotion-next)
  map  N <Plug>(easymotion-prev)

" Turning off Gdiff off while multiple windows are open
"  Simple way to turn off Gdiff splitscreen
"  works only when diff buffer is focused
  if !exists(":Gdiffoff")
    command Gdiffoff diffoff | q | Gedit
  endif

" Check the git blame
  nmap <Leader>b :Gblame<CR>








"" Gundo configuration
"    nmap <F5> :GundoToggle<CR>
"    imap <F5> <ESC>:GundoToggle<CR>
"
" set working dir to open file
" autocmd BufEnter * lcd %:p:h
" % to bounce from do to end etc.
" runtime! macros/matchit.vim

"" Include user's local vim config
"if filereadable(expand("~/.vimrc.local"))
"source ~/.vimrc.local
"endif

" shift + control + t reopens last closed window
"  nmap <c-s-t> :vs<bar>:b#<CR>  todo: conflicts with control+t

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
"  cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>


"" Shift tab will open current window in a new tab
"   nnoremap <S-tab> :tab split<CR>
"" then ZZ to close out
"" or
"" c-w-| to have window take over (if using vsplits).
"" c-w-= to restore.
"" c-w-_ for horizontal splits

"" neosnippet
"    let g:neosnippet#enable_completed_snippet = 1
"
