return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    keys = {
      {
        '<leader>lr',
        function() require('grug-far').open({ transient = true }) end,
        mode = { 'n' },
        desc = '[L]aunch find and [R]eplace',
      },
      {
        '<leader>lr',
        function() require('grug-far').with_visual_selection({ transient = true }) end,
        mode = { 'v' },
        desc = '[L]aunch find and [R]eplace (selection)',
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
      {
        '<leader>ld',
        function()
          local ok, oil = pcall(require, 'oil')
          local dir = ok and oil.get_current_dir() or vim.fn.expand '%:p:h'
          require('grug-far').open({ prefills = { paths = dir } })
        end,
        desc = '[L]aunch replace in current [D]irectory',
      },
      {
        '<leader>lb',
        function()
          local bufs = vim.tbl_filter(function(b)
            return vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= ''
          end, vim.api.nvim_list_bufs())
          local paths = table.concat(vim.tbl_map(vim.api.nvim_buf_get_name, bufs), ' ')
          require('grug-far').open({ prefills = { paths = paths } })
        end,
        desc = '[L]aunch replace in open [B]uffers',
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
