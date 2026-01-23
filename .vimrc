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

"  ____  _
" |  _ \| |_   _  __ _ ___
" | |_) | | | | |/ _` / __|
" |  __/| | |_| | (_| \__ \
" |_|   |_|\__,_|\__, |___/
"                |___/
" ===================================
"
" NERDTree configuration
" ---------------------
  let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
  let NERDTreeMinimalUI=1 "don't show '?' header
  let NERDTreeShowHidden=1 " show .dotfiles
  " Automatically delete the buffer of the file you just deleted with NerdTree:
  let NERDTreeAutoDeleteBuffer=1
  " close vim if the only window left open is NERDTree
  autocmd bufenter * if (winnr("$")    == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " opening directory
  autocmd StdinReadPre * let s:std_in   = 1
  " open up nerdTree whenever vim opens
  autocmd VimEnter * if argc()         == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" find file in nerdtree with leader key + n
  nnoremap <Leader>n :NERDTreeFind<CR>
" Toggle nerdtree with leader key + m
  nmap ,m :NERDTreeToggle<CR>

  " " Check if NERDTree is open or active
  " function! IsNERDTreeOpen()
  "   return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
  " endfunction

  " " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
  " " file, and we're not in vimdiff
  " function! SyncTree()
  "   if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
  "     NERDTreeFind
  "     wincmd p
  "   endif
  " endfunction

  " " Highlight currently open buffer in NERDTree
  " autocmd BufEnter * call SyncTree()

" ALE <3 ( async linter for es6, flow, js, swift, etc.. ) syntax highlighting and fixing linting
" ------------------------
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
  " Customize signs
  let g:ale_sign_error                  = '🍂'
  let g:ale_sign_warning                = '🍃'
" Make sure typescript files are set as tsx files
  augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.tsx set filetype=typescript.tsx
  augroup END

" rip-grep - in vim
" -----------------
  let g:rg_highlight                    = 1

" ALE completion disabled - CoC handles this better
  let g:ale_completion_enabled = 0
  let g:ale_completion_tsserver_autoimport = 0

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

" gitsigns.nvim (GitLens-like features)
" Keymaps are set in the Lua config below
" ]c / [c - next/prev hunk
" ,hs - stage hunk
" ,hu - undo stage hunk
" ,hp - preview hunk
" ,tb - toggle inline blame (GitLens-style)
" ,hd - diff this file

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
  set noshowmode " (remove redundant mode info)
  function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : 'lint warnings: ' . all_non_errors . ', errors:' . all_errors

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

" Markdown
  let vim_markdown_preview_hotkey='<C-m>'
  let vim_markdown_preview_github=1
  let vim_markdown_preview_browser='Google Chrome'

" Goyo
  nmap <C-g> :Goyo<CR>

" Conquer of Completion (CoC)
  let g:coc_global_extensions = [
        \ 'coc-snippets',
        \ 'coc-pairs',
        \ 'coc-tsserver',
        \ 'coc-eslint',
        \ 'coc-prettier',
        \ 'coc-json',
        \ ]

  " if hidden is not set, TextEdit might fail.
  set hidden

  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " Better display for messages
  set cmdheight=2

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300
    " updateTime: default = 4000(ms) = (4 seconds) no good for async update
    " set updatetime=500

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Or use `complete_info` if your vim support it, like:
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Create mappings for function text object, requires document symbols feature of languageserver.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  nmap <silent> <C-d> <Plug>(coc-range-select)
  xmap <silent> <C-d> <Plug>(coc-range-select)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Using CocList (prefix: ,c)
  " Show all diagnostics
  nnoremap <silent> <leader>ca  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
  " Resume latest coc list
  nnoremap <silent> <leader>cp  :<C-u>CocListResume<CR>


" FZF (mapped to ctrlT(control + t))
" -------------------------
  let $FZF_DEFAULT_COMMAND = 'rg --hidden -l ""'
  map <c-t> :FZF<CR>

" Vim-Clap 👏🏼
" <C-j>/<C-k>. remap these so it can work in the pop-up and my bubbling key
" maps don't break it
  autocmd FileType clap_input inoremap <silent> <buffer> <C-j> <C-R>=clap#handler#navigate_result('down')<CR>
  autocmd FileType clap_input inoremap <silent> <buffer> <C-k> <C-R>=clap#handler#navigate_result('up')<CR>
  nmap <c-c> :Clap<CR>

"            _
"   ___ ___ | | ___  _ __ ___
"  / __/ _ \| |/ _ \| '__/ __|
" | (_| (_) | | (_) | |  \__ \
"  \___\___/|_|\___/|_|  |___/
"-----------------------------

  " Let nvim inherit colors directly from iTerm2
  " This ensures perfect color harmony with your terminal
  set background=light
  " Don't set a colorscheme - let iTerm2 colors shine through
  colorscheme seoul256

  " Terminal color support
  set termguicolors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  " Let iTerm2 handle all colors - no overrides needed
  " This creates perfect harmony between terminal and editor

  " Allows customs :highlight preferences to be set
  syntax enable

  " Commands to switch background (nvim will inherit iTerm2 colors)
  command! LightBg set background=light | echo "🌅 Light background (using iTerm2 colors)"
  command! DarkBg set background=dark | echo "🌙 Dark background (using iTerm2 colors)"
  command! ToggleBg if &background == 'light' | DarkBg | else | LightBg | endif


  " Workaround some broken plugins which set guicursor indiscriminately.
  autocmd OptionSet guicursor noautocmd set guicursor=

  " Make the cursor blink
  " in normal / visual / command-line normal mode
  set guicursor+=n-v-c:blinkon50-blinkoff50
  " in insert/command-line Insert mode
  set guicursor+=i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150

  " Easily spot the cursor: highlights the screen line of the cursor
  " Disable cursor line highlighting as it's causing readability issues
  set nocursorline



"           _   _   _
"  ___  ___| |_| |_(_)_ __   __ _ ___
" / __|/ _ \ __| __| | '_ \ / _` / __|
" \__ \  __/ |_| |_| | | | | (_| \__ \
" |___/\___|\__|\__|_|_| |_|\__, |___/
"                         |___/
""""""""""""""""""""""""""""""""""""""

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

" but set other windows to default
"  augroup numbertoggle
"    autocmd!
"    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"  augroup END

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


"  _ __ ___ _ __ ___   __ _ _ __  ___
" | '__/ _ \ '_ ` _ \ / _` | '_ \/ __|
" | | |  __/ | | | | | (_| | |_) \__ \
" |_|  \___|_| |_| |_|\__,_| .__/|___/
"                          |_|
""""""""""""""""""""""""""""""""""""""

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
" Saving sessions to F2 and F3
  nnoremap <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
  nnoremap <F3> :source ~/vim_session <cr>     " And load session with F3

" type 'QQ' to save and quit out of vim quickly
  nnoremap QQ :conf xa<CR>
  nnoremap Q :conf q<CR>

" Map <leader> key to comma key too
  :nmap , <Leader>
  :vmap , <Leader>

" ==========================
" Bubbling 🧼
" ==========================
" Bubble single lines UP and DOWN
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
  nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
  nnoremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" space bar undo highlights search in normal mode
  nmap <space> :noh<CR>

"  EasyMotion config
  nmap / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)

"  These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
"  Without these mappings, `n` & `N` works fine. (These mappings just provide
"  different highlight method and have some other features )
  nmap n <Plug>(easymotion-next)
  nmap N <Plug>(easymotion-prev)

" Turning off Gdiff off while multiple windows are open
"  Simple way to turn off Gdiff splitscreen
"  works only when diff buffer is focused
  if !exists(":Gdiffoff")
    command Gdiffoff diffoff | q | Gedit
  endif

" Check the git blame
  nmap <Leader>b :Gblame<CR>

" t reopens last closed window
  nmap t :vs<bar>:b#<CR>





" set working dir to open file
" autocmd BufEnter * lcd %:p:h
" % to bounce from do to end etc.
" runtime! macros/matchit.vim


" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
"  cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
"
"

" copy current file path to buffer
nmap cp :let @" = expand("%")<cr>


"" Shift tab will open current window in a new tab
"   nnoremap <S-tab> :tab split<CR>
"" then ZZ to close out
"" or
"" c-w-| to have window take over (if using vsplits).
"" c-w-= to restore.
"" c-w-_ for horizontal splits

"" neosnippet
"    let g:neosnippet#enable_completed_snippet = 1




" ==========================
" Treesitter Configuration
" ==========================
" Better syntax highlighting and code understanding
" Wrapped in pcall to gracefully handle when plugin isn't installed yet
lua << EOF
local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if ok then
  treesitter.setup {
    ensure_installed = {
      "javascript",
      "typescript",
      "tsx",
      "lua",
      "vim",
      "vimdoc",
      "json",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "bash",
      "yaml",
      "python",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    -- Incremental selection: press Enter to expand selection, Backspace to shrink
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
      },
    },
  }
end

-- ==========================
-- Gitsigns Configuration (GitLens-like)
-- ==========================
local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
if gitsigns_ok then
  gitsigns.setup {
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
    },
    -- GitLens-like inline blame
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 300,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> • <summary>',
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true, desc='Next hunk'})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true, desc='Previous hunk'})

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, {desc='Stage hunk'})
      map('n', '<leader>hr', gs.reset_hunk, {desc='Reset hunk'})
      map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc='Stage hunk'})
      map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc='Reset hunk'})
      map('n', '<leader>hS', gs.stage_buffer, {desc='Stage buffer'})
      map('n', '<leader>hu', gs.undo_stage_hunk, {desc='Undo stage hunk'})
      map('n', '<leader>hR', gs.reset_buffer, {desc='Reset buffer'})
      map('n', '<leader>hp', gs.preview_hunk, {desc='Preview hunk'})
      map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc='Blame line (full)'})
      map('n', '<leader>tb', gs.toggle_current_line_blame, {desc='Toggle inline blame'})
      map('n', '<leader>hd', gs.diffthis, {desc='Diff this'})
      map('n', '<leader>hD', function() gs.diffthis('~') end, {desc='Diff this ~'})
      map('n', '<leader>td', gs.toggle_deleted, {desc='Toggle deleted'})
    end
  }
end

-- ==========================
-- Diffview Configuration
-- ==========================
local diffview_ok, diffview = pcall(require, 'diffview')
if diffview_ok then
  diffview.setup {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  }
  -- Keymaps for diffview
  vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', {desc='Open diff view'})
  vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory %<CR>', {desc='File history'})
  vim.keymap.set('n', '<leader>gH', ':DiffviewFileHistory<CR>', {desc='Repo history'})
  vim.keymap.set('n', '<leader>gc', ':DiffviewClose<CR>', {desc='Close diff view'})
end
EOF
