-- init.lua
-- vim.opt.shell = '/bin/nu'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = true
vim.g.python3_host_prog = '/Users/vustimenko/Code/installs/venvs/.venv/bin/python.3.14'

vim.o.relativenumber = true
vim.opt.termguicolors = true

vim.opt.undodir = os.getenv 'HOME' .. '/.cache/nvim/undodir'
vim.opt.foldlevelstart = 99

vim.o.sessionoptions = 'blank,buffers,folds,help,tabpages,winsize,winpos,localoptions'
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
vim.opt.diffopt:append 'algorithm:patience'
vim.opt.diffopt:append 'indent-heuristic'
vim.opt.diffopt:append 'inline:char'

vim.o.winborder = 'rounded'

_G._foldexpr = function()
  local buf = vim.api.nvim_get_current_buf()
  if #vim.lsp.get_clients { bufnr = buf } > 0 then
    return vim.lsp.foldexpr()
  end
  if vim.treesitter.highlighter.active[buf] then
    return vim.treesitter.foldexpr()
  end
  return '0'
end

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua._foldexpr()'
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldenable = true

vim.o.confirm = true
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
