local M = {}

function M.setup(bufnr)
  local bufopts = { buffer = bufnr }

  -- Remove Neovim 0.11 built-in LSP defaults (scheduled so they run after
  -- Neovim's own LspAttach handler has finished setting them)
  vim.schedule(function()
    pcall(vim.keymap.del, 'n',          'grn', { buffer = bufnr })
    pcall(vim.keymap.del, { 'n', 'x' }, 'gra', { buffer = bufnr })
    pcall(vim.keymap.del, 'n',          'grr', { buffer = bufnr })
    pcall(vim.keymap.del, 'n',          'gri', { buffer = bufnr })
    pcall(vim.keymap.del, 'n',          'gO',  { buffer = bufnr })
  end)

  vim.keymap.set('n', '<leader>md', vim.lsp.buf.definition,      vim.tbl_extend('force', bufopts, { desc = '[M]ove to [D]efinition' }))
  vim.keymap.set('n', '<leader>mD', vim.lsp.buf.declaration,     vim.tbl_extend('force', bufopts, { desc = '[M]ove to [D]eclaration' }))
  vim.keymap.set('n', '<leader>mt', vim.lsp.buf.type_definition,  vim.tbl_extend('force', bufopts, { desc = '[M]ove to [T]ype' }))
  vim.keymap.set('n', '<leader>mi', vim.lsp.buf.implementation,   vim.tbl_extend('force', bufopts, { desc = '[M]ove to [I]mplementation' }))
  local function show_refs(items)
    vim.fn.setqflist({}, ' ', { items = items, title = 'References' })
    vim.cmd 'botright copen'
    local qf_bufnr = vim.fn.getqflist({ qfbufnr = 0 }).qfbufnr
    vim.api.nvim_create_autocmd('CursorMoved', {
      buffer = qf_bufnr,
      callback = function()
        local qf_win = vim.api.nvim_get_current_win()
        vim.cmd('silent ' .. vim.fn.line '.' .. 'cc')
        vim.api.nvim_set_current_win(qf_win)
      end,
    })
  end

  vim.keymap.set('n', '<leader>sr', function()
    local cur = vim.api.nvim_buf_get_name(0)
    vim.lsp.buf.references(nil, {
      on_list = function(options)
        show_refs(vim.tbl_filter(function(item)
          return item.filename == cur
        end, options.items))
      end,
    })
  end, vim.tbl_extend('force', bufopts, { desc = '[S]how [R]eferences (file)' }))

  vim.keymap.set('n', '<leader>sR', function()
    vim.lsp.buf.references(nil, {
      on_list = function(options)
        show_refs(options.items)
      end,
    })
  end, vim.tbl_extend('force', bufopts, { desc = '[S]how [R]eferences (global)' }))
  vim.keymap.set('n', '<leader>rl', vim.lsp.buf.rename,           vim.tbl_extend('force', bufopts, { desc = '[R]ename [L]SP symbol' }))
  vim.keymap.set('n', '<leader>ss', vim.lsp.buf.document_symbol,  vim.tbl_extend('force', bufopts, { desc = '[S]how [S]ymbols' }))
  vim.keymap.set({ 'n', 'v' }, '<leader>sa', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = '[S]how [A]ctions' }))
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1, float = true }
  end, vim.tbl_extend('force', bufopts, { desc = 'Prev Diagnostic' }))
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1, float = true }
  end, vim.tbl_extend('force', bufopts, { desc = 'Next Diagnostic' }))
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Help' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Hover Documentation' }))
end

return M
