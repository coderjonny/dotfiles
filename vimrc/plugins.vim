" ===================================
" Plugin Configuration
" ===================================

" Automatically install missing plugins on startup
  if has('nvim')
      autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
  endif

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

  function! IsNERDTreeOpen()
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
  endfunction

  function! SyncTree()
    if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
      NERDTreeFind
      wincmd p
    endif
  endfunction

  autocmd BufEnter * call SyncTree()

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
" Make sure tsx files get the correct filetype for treesitter
  augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.tsx set filetype=typescriptreact
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
      \ 'colorscheme': 'PaperColor',
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
  autocmd CursorHold * call CocActionAsync('highlight')

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

" Vim-Clap
" <C-j>/<C-k>. remap these so it can work in the pop-up and my bubbling key
" maps don't break it
  autocmd FileType clap_input inoremap <silent> <buffer> <C-j> <C-R>=clap#handler#navigate_result('down')<CR>
  autocmd FileType clap_input inoremap <silent> <buffer> <C-k> <C-R>=clap#handler#navigate_result('up')<CR>
  nmap <c-c> :Clap<CR>

" BufExplorer - quickly change buffers
  " make tab open BufExplorer
  nnoremap <tab> :BufExplorer<CR>
