return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    keys = {
      {
        '<leader>rr',
        function() require('grug-far').open({ transient = true }) end,
        mode = { 'n' },
        desc = '[R]eplace',
      },
      {
        '<leader>rr',
        function() require('grug-far').with_visual_selection({ transient = true }) end,
        mode = { 'v' },
        desc = '[R]eplace (selection)',
      },
      {
        '<leader>rw',
        function()
          require('grug-far').open({ prefills = { search = vim.fn.expand '<cword>' } })
        end,
        desc = '[R]eplace [W]ord under cursor',
      },
      {
        '<leader>rf',
        function()
          require('grug-far').open({ prefills = { paths = vim.fn.expand '%' } })
        end,
        desc = '[R]eplace in [F]ile',
      },
      {
        '<leader>rd',
        function()
          local ok, oil = pcall(require, 'oil')
          local dir = ok and oil.get_current_dir() or vim.fn.expand '%:p:h'
          require('grug-far').open({ prefills = { paths = dir } })
        end,
        desc = '[R]eplace in [D]irectory',
      },
      {
        '<leader>rb',
        function()
          local bufs = vim.tbl_filter(function(b)
            return vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= ''
          end, vim.api.nvim_list_bufs())
          local paths = table.concat(vim.tbl_map(vim.api.nvim_buf_get_name, bufs), ' ')
          require('grug-far').open({ prefills = { paths = paths } })
        end,
        desc = '[R]eplace in [B]uffers',
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
