return {
  {
    'romgrk/barbar.nvim',
    event = 'BufAdd',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    opts = {
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = true,
      exclude_ft = { 'javascript' },
      exclude_name = { 'package.json' },
      focus_on_close = 'left',
      hide = { extensions = true, inactive = true },
      highlight_alternate = false,
      highlight_inactive_file_icons = false,
      highlight_visible = true,
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        filetype = {
          custom_colors = false,
          enabled = true,
        },
        separator = { left = '▎', right = '' },
        separator_at_end = true,
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        preset = 'default',
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },
    },
    version = '^1.0.0',

    config = function(_, opts)
      require('barbar').setup(opts)
      local map = vim.keymap.set
      local km = { noremap = true, silent = true }
      map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', km)
      map('n', '<A-.>', '<Cmd>BufferNext<CR>', km)

      map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', km)
      map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', km)

      map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', km)
      map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', km)
      map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', km)
      map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', km)
      map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', km)
      map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', km)
      map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', km)
      map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', km)
      map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', km)
      map('n', '<A-0>', '<Cmd>BufferLast<CR>', km)

      map('n', '<A-p>', '<Cmd>BufferPin<CR>', km)
      map('n', '<A-c>', '<Cmd>BufferClose<CR>', km)
    end,
  },
  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    opts = {
      show_icons = true,
      leader_key = ';', -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        treesitter = {
          label = { rainbow = { enabled = true } },
        },
        char = {
          enabled = true,
          search = { wrap = true },
          highlight = { backdrop = true },
          jump = { register = true },
        },
      },
      jump = {
        autojump = true,
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
    },
  },

  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
    lazy = false,
    opts = {
      frecency = { enabled = true },
      layout = {
        height = 0.8,
        width = 0.8,
        preview_position = 'right',
        preview_size = 0.5,
      },
    },
    keys = {
      {
        '<leader>fd',
        function()
          local ok, oil = pcall(require, 'oil')
          local dir = ok and oil.get_current_dir()
          if dir then
            require('fff').find_files_in_dir(dir)
          else
            require('fff').find_files()
          end
        end,
        desc = '[F]ind files in current dir',
      },
      { '<leader>fD', function() require('fff').find_files() end, desc = '[F]ind all files' },
      { '<leader>ff', function() require('fff').live_grep() end, desc = '[F]ind text' },
      { '<leader>fF', function() require('fff').live_grep() end, desc = '[F]ind text project-wide' },
    },
  },
}
