" ===================================
" Key Mappings
" ===================================

" escape out of i mode
  inoremap jj <ESC>
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
" Bubbling
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

" copy current file path to buffer
nmap cp :let @" = expand("%")<cr>

" escaping terminal window easier with esc key
  tnoremap <Esc> <C-\><C-n>

" Keymap: Ctrl+\ to toggle terminal
nnoremap <silent> <C-\> :lua toggle_terminal()<CR>
" Also allow toggling from within terminal
tnoremap <silent> <C-\> <C-\><C-n>:lua toggle_terminal()<CR>
