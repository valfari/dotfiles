_G._git_ref_complete = function(arglead)
  local refs = vim.fn.systemlist 'git branch --all --format="%(refname:short)" 2>/dev/null && git tag 2>/dev/null'
  if arglead == '' then
    return refs
  end
  return vim.tbl_filter(function(r)
    return r:find(arglead, 1, true) ~= nil
  end, refs)
end

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

        map('n', '<leader>sg', function()
          local branch = vim.fn.systemlist 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
          local result = (branch and branch[1] and branch[1] ~= '') and branch[1] or nil
          vim.notify('Branch: ' .. (result or 'null'))
        end, '[S]how [G]it branch')

        map('n', '<leader>tg', function()
          local blame_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'gitsigns-blame' then
              blame_win = win
              break
            end
          end
          if blame_win then
            vim.api.nvim_win_close(blame_win, false)
            vim.notify('Git blame: off')
          else
            local origin = vim.api.nvim_get_current_win()
            vim.api.nvim_create_autocmd('WinEnter', {
              once = true,
              callback = function()
                if vim.bo[vim.api.nvim_win_get_buf(0)].filetype == 'gitsigns-blame' then
                  vim.api.nvim_set_current_win(origin)
                end
              end,
            })
            gs.blame()
            vim.notify('Git blame: on')
          end
        end, '[G]it blame')

        local _word_diff_on = false
        map('n', '<leader>td', function()
          gs.toggle_word_diff()
          _word_diff_on = not _word_diff_on
          vim.notify('Word diff: ' .. (_word_diff_on and 'on' or 'off'))
        end, '[D]iff word-level')

        -- Stage / reset hunks
        map({ 'n', 'x' }, '<leader>ds', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, '[D]iff [S]tage hunk')
        map('n', '<leader>dS', gs.stage_buffer, '[D]iff [S]tage buffer')
        map({ 'n', 'x' }, '<leader>dR', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, '[D]iff [R]eset hunk')
        map('n', '<leader>du', gs.undo_stage_hunk, '[D]iff [U]ndo stage')

        -- Diff buffer with input
        map('n', '<leader>db', function()
          local ref = vim.fn.input { prompt = 'Diff vs (empty = index): ', completion = 'customlist,v:lua._git_ref_complete' }
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
      show_untracked = true,
      keymaps = {
        file_panel = {
          {
            { 'n', 'x' },
            'X',
            function()
              local lib = require 'diffview.lib'
              local vcs_utils = require 'diffview.vcs.utils'
              local view = lib.get_current_view()
              if not view then return end
              local panel = view.panel

              local start_line = vim.fn.line '.'
              local end_line = start_line
              local mode = vim.fn.mode()
              if mode == 'V' or mode == 'v' then
                start_line = vim.fn.line 'v'
                end_line = vim.fn.line '.'
                if start_line > end_line then
                  start_line, end_line = end_line, start_line
                end
              end

              local seen = {}
              local entries = {}
              panel.components.comp:deep_some(function(comp)
                local line = comp.lstart + 1
                if comp:isleaf() and line >= start_line and line <= end_line then
                  local file_entries = {}
                  if comp.name == 'file' then
                    file_entries = { comp.context }
                  elseif comp.name == 'dir_name' then
                    local node = comp.parent and comp.parent.context and comp.parent.context._node
                    if node then
                      for _, leaf in ipairs(node:leaves()) do
                        if leaf.data then
                          file_entries[#file_entries + 1] = leaf.data
                        end
                      end
                    end
                  end
                  for _, fe in ipairs(file_entries) do
                    if not seen[fe.path] then
                      seen[fe.path] = true
                      entries[#entries + 1] = fe
                    end
                  end
                end
                return false
              end)

              if #entries == 0 then return end

              local label = #entries == 1 and entries[1].path or (#entries .. ' entries')
              local ok = vim.fn.confirm('Restore ' .. label .. ' from ref? (overwrites local)', '&Yes\n&No', 2)
              if ok ~= 1 then return end

              for _, fe in ipairs(entries) do
                vcs_utils.restore_file(view.adapter, fe.path, fe.kind, nil)
              end
              view:update_files()
            end,
            { desc = 'Restore entry/entries from ref (overwrite local)' },
          },
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
          local ref = vim.fn.input { prompt = 'Diff vs (empty = working tree): ', completion = 'customlist,v:lua._git_ref_complete' }
          if ref == '' then
            vim.cmd 'DiffviewOpen'
          else
            vim.cmd('DiffviewOpen ' .. ref)
          end
        end,
        desc = '[D]iff [D]iffview',
      },
      { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff [H]istory (buffer)' },
      { '<leader>dH', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff [H]istory (all)' },
      { '<leader>dq', '<cmd>DiffviewClose<cr>', desc = '[D]iff [Q]uit' },
    },
  },
}
