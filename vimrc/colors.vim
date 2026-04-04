" ===================================
" Colors & Theme
" ===================================

  " PaperColor theme - high contrast light mode
  " set background=light
  " Try to load PaperColor immediately (if plugin already in runtimepath)
  silent! colorscheme PaperColor
  " Ensure it loads after all plugins initialize (backup for first-time installs)
  autocmd VimEnter * ++once silent! colorscheme PaperColor

  " Terminal color support
  set termguicolors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  " Let iTerm2 handle all colors - no overrides needed
  " This creates perfect harmony between terminal and editor

  " Allows customs :highlight preferences to be set
  syntax enable

  " Commands to switch background with PaperColor
  command! Light set background=light | colorscheme PaperColor | echo "Light background (PaperColor)"
  command! Dark set background=dark | colorscheme slate | echo "Dark background (slate)"
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
