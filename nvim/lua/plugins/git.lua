return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged_enable = true,
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation
        map('n', ']g', function()
          gs.nav_hunk 'next'
        end, 'Next hunk')
        map('n', '[g', function()
          gs.nav_hunk 'prev'
        end, 'Prev hunk')

        -- Show blame
        map('n', '<leader>sb', function()
          gs.blame_line { full = true }
        end, '[S]how [B]lame')

        local _blame_on = false
        map('n', '<leader>tg', function()
          gs.toggle_current_line_blame()
          _blame_on = not _blame_on
          vim.notify('Git blame: ' .. (_blame_on and 'on' or 'off'))
        end, '[G]it blame')

        local _word_diff_on = false
        map('n', '<leader>td', function()
          gs.toggle_word_diff()
          _word_diff_on = not _word_diff_on
          vim.notify('Word diff: ' .. (_word_diff_on and 'on' or 'off'))
        end, '[D]iff word-level')

        -- Diff buffer with input
        map('n', '<leader>db', function()
          local ref = vim.fn.input 'Diff vs (empty = index): '
          if ref == '' then
            gs.diffthis()
          else
            gs.diffthis(ref)
          end
        end, '[D]iff [B]uffer')

        -- Text object
        map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
      end,
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = 'diff2_vertical',
          winbar_info = true,
        },
        file_history = {
          layout = 'diff2_vertical',
          winbar_info = true,
        },
      },
      file_panel = {
        win_config = {
          width = 30,
        },
      },
    },
    config = function(_, opts)
      require('diffview').setup(opts)
      vim.opt.fillchars:append 'vert:│'
      vim.opt.diffopt:append 'algorithm:histogram,indent-heuristic,linematch:60'

      local function set_hl()
        local comment = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
        vim.api.nvim_set_hl(0, 'DiffviewWinSeparator', {
          fg = comment.fg,
          bg = comment.bg,
          bold = true,
        })
      end

      set_hl()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = set_hl })
    end,
    keys = {
      {
        '<leader>dd',
        function()
          local ref = vim.fn.input 'Diff vs (empty = working tree): '
          if ref == '' then
            vim.cmd 'DiffviewOpen'
          else
            vim.cmd('DiffviewOpen ' .. ref)
          end
        end,
        desc = '[D]iff [D]iffview',
      },
      { '<leader>dh', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff [H]istory' },
      { '<leader>dq', '<cmd>DiffviewClose<cr>', desc = '[D]iff [Q]uit' },
    },
  },
}
