-- [[ init.lua ]]
-- Core editor settings, keymaps, commands and autocommands.
-- External plugins are defined in `lua/plugins.lua`.

-- Set <space> as the leader key (must be set before plugins load).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal.
vim.g.have_nerd_font = false

-- [[ Options ]] (see `:help vim.opt`)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Sync clipboard with the OS (scheduled to avoid startup cost).
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- [[ Keymaps ]] (see `:help vim.keymap.set()`)

-- Clear search highlights on <Esc>.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics.
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- File explorer (netrw).
vim.keymap.set('n', '<leader>kv', ':Explore<CR>', { desc = 'File explorer' })
vim.keymap.set('n', '\\', ':Explore<CR>', { desc = 'File explorer' })

-- Exit terminal mode.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation with CTRL+<hjkl>.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Telescope quick file find.
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })

-- Navigate the jump list.
vim.keymap.set('n', '<C-_>', '<C-o>', { desc = 'Go back (jump list)' })
vim.keymap.set('n', '<C-->', '<C-o>', { desc = 'Go back (jump list)' })
vim.keymap.set('n', '<C-=>', '<C-i>', { desc = 'Go forward (jump list)' })
vim.keymap.set('n', '<C-+>', '<C-i>', { desc = 'Go forward (jump list)' })

-- [[ User commands ]]

-- Restart the TypeScript language server.
vim.api.nvim_create_user_command('RestartTSServer', function()
  vim.cmd 'LspStop tsserver'
  vim.cmd 'LspStart tsserver'
  print 'TypeScript server restarted'
end, {})

-- Copy the absolute path of the current file.
vim.api.nvim_create_user_command('Copypath', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify(path, vim.log.levels.INFO)
end, {})

-- Copy the path of the current file relative to the project (git) root.
vim.api.nvim_create_user_command('Copyrelativepath', function()
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.expand '%:p:h') .. ' rev-parse --show-toplevel')[1]
  local root = (vim.v.shell_error == 0 and git_root and git_root ~= '') and git_root or vim.fn.getcwd()
  local rel_path = vim.fn.expand('%:p'):sub(#root + 2)
  vim.fn.setreg('+', rel_path)
  vim.notify(rel_path, vim.log.levels.INFO)
end, {})

-- [[ Autocommands ]] (see `:help lua-guide-autocommands`)

-- Highlight text when yanking.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Bootstrap lazy.nvim ]] (see https://github.com/folke/lazy.nvim)
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Load plugins ]] (defined in lua/plugins.lua)
require('lazy').setup(require 'plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Enable the oxlint language server.
vim.lsp.enable 'oxlint'

-- vim: ts=2 sts=2 sw=2 et
