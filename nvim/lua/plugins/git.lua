return {
  {
    'tanvirtin/vgit.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('vgit').setup {
        settings = {
          live_gutter = {
            enabled = false, -- gitsigns handles gutter signs
          },
        },
      }
    end,
    keys = {
      -- Hunk navigation
      { ']g', function() require('vgit').hunk_down() end, desc = 'Next git hunk' },
      { '[g', function() require('vgit').hunk_up() end, desc = 'Prev git hunk' },
      -- Buffer operations
      { '<leader>gp', function() require('vgit').buffer_hunk_preview() end, desc = 'Preview hunk' },
      { '<leader>gs', function() require('vgit').buffer_hunk_stage() end, desc = 'Stage hunk' },
      { '<leader>gr', function() require('vgit').buffer_hunk_reset() end, desc = 'Reset hunk' },
      { '<leader>gB', function() require('vgit').buffer_blame_preview() end, desc = 'Blame line' },
      { '<leader>gH', function() require('vgit').buffer_history_preview() end, desc = 'File history' },
      -- Toggles
      { '<leader>tb', function() require('vgit').toggle_live_blame() end, desc = 'Toggle live blame' },
      -- Project-wide (lazygit replacement)
      { '<leader>gg', function() require('vgit').project_diff_preview() end, desc = 'Project diff' },
      { '<leader>gl', function() require('vgit').project_logs_preview() end, desc = 'Project logs' },
      { '<leader>gC', function() require('vgit').project_commit_preview() end, desc = 'Commit' },
      { '<leader>gS', function() require('vgit').project_stash_preview() end, desc = 'Stash' },
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
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup()
    end,
    keys = { '<leader>gy' },
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
