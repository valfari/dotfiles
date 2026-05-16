return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    keys = {
      {
        '<leader>lr',
        function() require('grug-far').open({ transient = true }) end,
        mode = { 'n', 'v' },
        desc = '[L]aunch find and [R]eplace',
      },
      {
        '<leader>lw',
        function()
          require('grug-far').open({ prefills = { search = vim.fn.expand '<cword>' } })
        end,
        desc = '[L]aunch replace [W]ord under cursor',
      },
      {
        '<leader>lf',
        function()
          require('grug-far').open({ prefills = { paths = vim.fn.expand '%' } })
        end,
        desc = '[L]aunch replace in current [F]ile',
      },
    },
  },
  { 'NMAC427/guess-indent.nvim', enabled = false },
  { 'matze/vim-move', enabled = false },
  { 'mg979/vim-visual-multi', enabled = false },
  {
    'kylechui/nvim-surround',
    version = '^3.0.0',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
}
