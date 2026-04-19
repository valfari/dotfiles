return {
  {
    'SuperBo/fugit2.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit',
        dependencies = { 'stevearc/dressing.nvim' },
      },
    },
    cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph', 'Fugit2Rebase' },
    opts = {
      width = 100,
      external_diffview = true, -- hand diffs off to diffview.nvim
    },
    keys = {
      { '<leader>gg', '<cmd>Fugit2<cr>', desc = 'Fugit2 status' },
      { '<leader>gG', '<cmd>Fugit2Graph<cr>', desc = 'Fugit2 graph' },
      { '<leader>gR', '<cmd>Fugit2Rebase<cr>', desc = 'Fugit2 rebase' },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    opts = {
      view = { default = { layout = 'diff2_horizontal' } }, -- Default side-by-side
      hooks = {
        diff_buf_read = function(bufnr)
          vim.b[bufnr].view_activated = 1
        end,
      },
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff Overview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History' },
      { '<leader>gm', '<cmd>DiffviewOpen MERGE_HEAD<cr>', desc = 'Merge Conflicts' },
    },
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = true,
  },
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {},
    keys = {
      { '<leader>gy', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Yank git link' },
      { '<leader>gY', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open git link in browser' },
    },
  },
  {
    'echasnovski/mini.diff',
    version = false,
    opts = {
      -- gitsigns already owns the gutter; use empty signs here
      view = {
        style = 'sign',
        signs = { add = '', change = '', delete = '' },
      },
      mappings = {
        apply = 'gh',
        reset = 'gH',
        textobject = 'gh',
        goto_first = '[H',
        goto_prev = '[h',
        goto_next = ']h',
        goto_last = ']H',
      },
    },
    keys = {
      -- Toggle the inline overlay (shows ref text side-by-side in the buffer)
      {
        '<leader>go',
        function() require('mini.diff').toggle_overlay(0) end,
        desc = 'Diff overlay toggle',
      },
      -- Diff current buffer vs system clipboard
      {
        '<leader>gc',
        function()
          require('mini.diff').set_ref_text(0, vim.fn.getreg '+')
        end,
        desc = 'Diff vs clipboard',
      },
      -- Diff current buffer vs an arbitrary git ref (branch, commit, tag…)
      {
        '<leader>gv',
        function()
          vim.ui.input({ prompt = 'Git ref to diff against: ' }, function(ref)
            if not ref or ref == '' then return end
            local path = vim.api.nvim_buf_get_name(0)
            local lines = vim.fn.systemlist('git show ' .. ref .. ':' .. path)
            if vim.v.shell_error ~= 0 then
              vim.notify('git show failed: ' .. table.concat(lines, '\n'), vim.log.levels.ERROR)
              return
            end
            require('mini.diff').set_ref_text(0, lines)
          end)
        end,
        desc = 'Diff vs git ref',
      },
      -- Reset ref back to git index (HEAD)
      {
        '<leader>gV',
        function()
          require('mini.diff').set_source(0, require('mini.diff').gen_source.git())
        end,
        desc = 'Diff reset to git HEAD',
      },
    },
  },
}
