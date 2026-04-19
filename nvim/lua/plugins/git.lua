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
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation
        map('n', ']g', function() gs.nav_hunk('next') end, 'Next hunk')
        map('n', '[g', function() gs.nav_hunk('prev') end, 'Prev hunk')

        -- Hunk operations
        map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
        map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage hunk')
        map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset hunk')
        map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')

        -- Preview & blame
        map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>gB', function() gs.blame_line { full = true } end, 'Blame line')
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle inline blame')
      end,
    },
  },
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    opts = {
      diff = {
        layout = 'side-by-side',
        disable_inlay_hints = true,
      },
      explorer = {
        position = 'left',
        width = 40,
        view_mode = 'list',
      },
    },
    keys = {
      { '<leader>dd', '<cmd>CodeDiff<cr>', desc = 'Diff explorer' },
      { '<leader>dh', '<cmd>CodeDiff HEAD<cr>', desc = 'Diff vs HEAD' },
    },
  },
}
