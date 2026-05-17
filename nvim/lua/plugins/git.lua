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

        -- Hunk operations
        map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
        map('v', '<leader>gs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage hunk')
        map('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset hunk')
        map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')

        -- Preview & blame
        map('n', '<leader>gp', gs.preview_hunk_inline, 'Preview hunk inline')
        map('n', '<leader>gP', gs.preview_hunk, 'Preview hunk (float)')
        map('n', '<leader>gB', function()
          gs.blame_line { full = true }
        end, 'Blame line')
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

        -- Diff this buffer
        map('n', '<leader>gd', gs.diffthis, 'Diff buffer vs index')
        map('n', '<leader>gD', function()
          gs.diffthis '~'
        end, 'Diff buffer vs last commit')
        -- Quickfix
        map('n', '<leader>gq', gs.setqflist, 'Hunks to quickfix')

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
      { '<leader>dd', '<cmd>DiffviewOpen<cr>', desc = '[D]iff [D]iffview (working tree)' },
      { '<leader>dh', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff [H]istory' },
      {
        '<leader>db',
        function()
          local branch = vim.fn.input 'Branch to diff: '
          if branch == '' then
            vim.notify('No branch given', vim.log.levels.WARN)
            return
          end
          vim.cmd('DiffviewOpen ' .. branch)
        end,
        desc = '[D]iff vs [B]ranch',
      },
      { '<leader>dq', '<cmd>DiffviewClose<cr>', desc = '[D]iff [Q]uit' },
    },
  },
}
