return {
  {
    'aznhe21/actions-preview.nvim',
    enabled = false,
    event = 'LspAttach',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      local ap = require 'actions-preview'
      ap.setup {
        -- Default configuration (customize as needed):
        diff = {
          ctxlen = 3, -- Context lines for vim.diff()
        },
        highlight_command = {
          -- Optional: Add external diff highlighters (e.g., delta)
          -- require("actions-preview.highlight").delta(),
        },
        backend = { 'nui', 'minipick', 'snacks' }, -- Preferred backends (telescope is default)
        nui = { -- Options for nui backend (if used)
          dir = 'col',
          keymap = nil,
          layout = {
            position = '50%',
            size = {
              width = '60%',
              height = '90%',
            },
            min_width = 40,
            min_height = 10,
            relative = 'editor',
          },
          preview = {
            size = '60%',
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
          },
          select = {
            size = '40%',
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
          },
        },
        snacks = {
          layout = { preset = 'default' },
        },
      }
    end,
  },
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}
