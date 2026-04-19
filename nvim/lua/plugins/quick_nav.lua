return {
  {
    'romgrk/barbar.nvim',
    event = 'BufAdd',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = true
    end,
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

    config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

      map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

      map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
      map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
      map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
      map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
      map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
      map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
      map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
      map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
      map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
      map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

      map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
      map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
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
    'ibhagwan/fzf-lua',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { 'skim' },
    config = function()
      local fzf = require 'fzf-lua'

      -- Common excludes: only .git + some large/noisy dirs you probably never want
      local common_excludes = {
        '--exclude',
        '.git', -- ONLY .git is fully excluded
        '--exclude',
        'node_modules',
        '--exclude',
        '.venv',
        '--exclude',
        '.cache',
        '--exclude',
        'Library',
        '--exclude',
        'Pictures',
        '--exclude',
        'Movies',
        '--exclude',
        'Music',
        '--exclude',
        'Desktop',
      }

      -- Convert to space-separated string for fd_opts
      local fd_excludes = table.concat(common_excludes, ' ')

      -- For ripgrep: use glob negation, but only exclude .git directory contents
      local rg_globs = {
        '--hidden',
        '--glob=!.git/*', -- exclude everything inside .git
        '--glob=!node_modules/*',
        '--glob=!.venv/*',
        '--glob=!.cache/*',
        '--glob=!Library/*',
        '--glob=!Pictures/*',
        '--glob=!Movies/*',
        '--glob=!Music/*',
        '--glob=!Desktop/*',
      }
      local rg_opts = table.concat(rg_globs, ' ')

      fzf.setup {
        'fzf-native',
        winopts = {
          preview = { default = 'bat' },
        },
        keymap = {
          fzf = {
            ['ctrl-u'] = 'preview-page-up',
            ['ctrl-d'] = 'preview-page-down',
            ['ctrl-k'] = 'up',
            ['ctrl-j'] = 'down',
            ['ctrl-q'] = 'abort',
          },
        },
        fzf_opts = {
          ['--tiebreak'] = 'index',
        },
        defaults = {
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },

        -- File finder: include hidden files/dirs, exclude only .git + noisy dirs
        files = {
          fd_opts = '--type f --hidden --strip-cwd-prefix ' .. fd_excludes,
          previewer = 'bat',
        },

        -- Grep & live_grep: search hidden files, but never enter .git
        grep = {
          rg_opts = '--column --line-number --no-heading --color=always --smart-case ' .. rg_opts,
          previewer = 'bat',
        },
        live_grep = {
          rg_opts = '--column --line-number --no-heading --color=always --smart-case ' .. rg_opts,
          previewer = 'bat',
        },

        buffers = {
          sort_lastused = true,
          previewer = 'bat',
        },

        git = {
          files = { previewer = 'bat' },
        },
      }

      fzf.register_ui_select()

      local keymap = vim.keymap.set

      -- Resume last search
      keymap('n', '<leader>fr', fzf.resume, { desc = '[F]ind [R]esume' })

      -- Grep / Live grep
      keymap('n', '<leader>ff', function()
        fzf.live_grep { cwd = require('oil').get_current_dir() }
      end, { desc = '[F]ind Text in current [D]irectory' })

      keymap('n', '<leader>fF', fzf.live_grep, { desc = '[F]ind text (project-wide)' })

      keymap('v', '<leader>ff', function()
        require('fzf-lua').grep_visual()
      end, { desc = '[F]ind text from visual selection' })

      -- LSP symbols
      keymap('n', '<leader>fs', function()
        fzf.lsp_document_symbols {
          symbol_types = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
        }
      end, { desc = '[F]ind LSP [S]ymbols' })

      -- Files
      keymap('n', '<leader>fg', fzf.git_files, { desc = '[F]ind [G]it Files' })
      keymap('n', '<leader>fD', fzf.files, { desc = '[F]ind All Files (incl. hidden)' })
      keymap('n', '<leader>fd', function()
        fzf.files { cwd = require('oil').get_current_dir() }
      end, { desc = '[F]ind files in current [D]irectory' })
      keymap('n', '<leader>fR', fzf.oldfiles, { desc = '[F]ind [R]ecent Files' })

      -- Fuzzy search current buffer
      keymap('n', '/', function()
        fzf.blines { previewer = false }
      end, { desc = 'Fuzzily search in current buffer' })
    end,
  },
}
