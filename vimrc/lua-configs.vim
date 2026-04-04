" ===================================
" Lua Plugin Configurations
" ===================================

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

-- ==========================
-- Telescope Configuration
-- ==========================
local telescope_ok, telescope = pcall(require, 'telescope')
if telescope_ok then
  telescope.setup {
    defaults = {
      file_ignore_patterns = { "node_modules", ".git/" },
    },
  }
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
end


-- ==========================
-- CursorHold Timeout (decouple CursorHold from updatetime)
-- ==========================
local ct_ok, ct = pcall(require, 'cursorhold-timeout')
if ct_ok then
  ct.setup({ timeout = 300 })
end
EOF

" ==========================
" Floating Terminal Toggle
" ==========================
" Toggle persistent floating terminal with Ctrl+\
" Automatically enters insert mode on open
" Reuses same terminal session across toggles
lua << EOF
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  -- If terminal window is visible, hide it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  -- Create terminal buffer if it doesn't exist
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true) -- nofile, scratch buffer
    vim.api.nvim_buf_call(term_buf, function()
      -- Start bash as a login shell to source ~/.bash_profile
      -- The -l flag makes bash read ~/.bash_profile
      local shell_cmd = vim.o.shell == 'bash' and 'bash -l' or vim.o.shell
      vim.fn.termopen(shell_cmd, {
        on_exit = function()
          -- Clean up when terminal exits
          term_buf = nil
          term_win = nil
        end
      })
    end)
  end

  -- Calculate floating window size (80% of editor)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Open floating window
  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  })

  -- Enter insert mode automatically
  vim.cmd('startinsert')
end

-- Expose function globally
_G.toggle_terminal = toggle_terminal
EOF
