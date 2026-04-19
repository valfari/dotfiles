return {
  {
    'numToStr/Comment.nvim',
    opts = {
      opleader = {
        line = '<leader>tcl',
        block = '<leader>tcb',
      },
    },
  },
  {
    'RRethy/vim-illuminate',
    opts = {
      providers = { 'lsp', 'treesitter', 'regex' }, -- Prioritize LSP/Treesitter for accuracy
      delay = 20,
      filetypes_denylist = { 'dirvish', 'fugitive', 'NvimTree' },
      under_cursor = true,
      large_file_cutoff = 10000,
      large_file_overrides = nil,
      min_count_to_highlight = 1,
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underline = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underline = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underline = true, bold = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'nu',
        'python',
        'rust',
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'json',
        'yaml',
        'toml',
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { 'ruby', 'python', 'c' },
      },
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    },
    config = function(_, opts)
      require('ufo').setup(opts)
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local map = vim.keymap.set
      -- map('n', 'za', 'za', { desc = 'Toggle ffold ' })
      map('n', 'zc', 'zc', { desc = 'Close ffold' })
      map('n', 'zo', 'zo', { desc = 'Open ffold' })
      map('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      map('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    end,
  },
}
