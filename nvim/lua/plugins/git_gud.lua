return {
  {
    'tris203/precognition.nvim',
    enabled = false,
    -- event = 'VeryLazy',
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>t', group = 'Toggle' },
        { '<leader>y', group = 'Yank' },
        { '<leader>d', group = 'Diff' },
        { '<leader>r', group = 'Replace' },
        { '<leader>f', group = 'Find' },
        { '<leader>m', group = 'Move' },
        { '<leader>s', group = 'Show' },
        { '<leader>e', group = 'Execute' },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
}
