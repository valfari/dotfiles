require 'options'

require('lazy').setup({
  {
    'sainnhe/everforest',
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comments = 1
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = { flavour = 'frappe' },
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    opts = {},
  },
  { 'folke/tokyonight.nvim', priority = 1000, opts = { style = 'night' } },
  { 'rebelot/kanagawa.nvim', priority = 1000, opts = {} },
  { 'rose-pine/neovim', name = 'rose-pine', enabled = false, priority = 1000, opts = {} },
  { 'EdenEast/nightfox.nvim', enabled = false, priority = 1000, opts = {} },
  { 'navarasu/onedark.nvim', enabled = false, priority = 1000, opts = {} },
  { import = 'plugins' },
}, {
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

-- Apply initial theme
vim.o.background = 'dark'
vim.cmd.colorscheme 'gruvbox'

require 'keymaps'

require('statusline')
require 'spell'
