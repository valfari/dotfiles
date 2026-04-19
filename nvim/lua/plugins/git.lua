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
        map('n', '<leader>gp', gs.preview_hunk_inline, 'Preview hunk inline')
        map('n', '<leader>gP', gs.preview_hunk, 'Preview hunk (float)')
        map('n', '<leader>gB', function() gs.blame_line { full = true } end, 'Blame line')
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle inline blame')
        map('n', '<leader>tw', gs.toggle_word_diff, 'Toggle word diff')

        -- Diff this buffer
        map('n', '<leader>gd', gs.diffthis, 'Diff buffer vs index')
        map('n', '<leader>gD', function() gs.diffthis('~') end, 'Diff buffer vs last commit')

        -- Quickfix
        map('n', '<leader>gq', gs.setqflist, 'Hunks to quickfix')

        -- Text object
        map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
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
        compute_moves = false,
      },
      explorer = {
        position = 'left',
        width = 40,
        view_mode = 'tree',
        flatten_dirs = true,
        indent_markers = true,
        visible_groups = { staged = true, unstaged = true, conflicts = true },
      },
    },
    keys = {
      { '<leader>dd', '<cmd>CodeDiff<cr>', desc = 'Diff explorer' },
      { '<leader>dh', '<cmd>CodeDiff HEAD<cr>', desc = 'Diff vs HEAD' },
      { '<leader>dH', '<cmd>CodeDiff history<cr>', desc = 'Diff commit history' },
    },
  },
}
