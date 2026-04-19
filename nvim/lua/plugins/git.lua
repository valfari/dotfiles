return {
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    -- optional for floating window border decoration
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      floating_window_winblend = 0, -- 0-100 transparency
      floating_window_scaling_factor = 0.9, -- Size as % of editor
      floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }, -- Pretty borders
      use_neovim_remote = true, -- Edit commits in Neovim (requires neovim-remote installed via pip)
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit (root dir)' },
      { '<leader>gG', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit (current file)' },
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
    'f-person/git-blame.nvim',
    opts = { enabled = false, date_format = '%r' },
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
