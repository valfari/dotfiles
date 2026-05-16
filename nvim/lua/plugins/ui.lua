return {
  {
    'rcarriga/nvim-notify',
    opts = {
      render = 'minimal',
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  { 'dstein64/nvim-scrollview' },
  {
    'sphamba/smear-cursor.nvim',
    enabled = false,
    event = 'VeryLazy',
    cond = vim.g.neovide == nil,
    opts = {
      hide_target_hack = true,
      cursor_color = 'none',
      stiffness = 0.8,
      trailing_stifness = 0.5,
      distance_stop_animating = 0.5,
    },
    specs = {
      {
        'echasnovski/mini.animate',
        optional = true,
        opts = {
          cursor = { enable = false },
        },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    enabled = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'akinsho/toggleterm.nvim', enabled = false, version = '*', config = true },
  {
    'karb94/neoscroll.nvim',
    enabled = false,
    opts = {
      easing = 'quadratic',
    },
  },
}
