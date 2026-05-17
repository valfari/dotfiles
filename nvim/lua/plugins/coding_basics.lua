return {
  {
    'folke/trouble.nvim',
    enabled = false,
    cmd = 'Trouble',
    opts = {
      modes = {
        lsp_references = {
          auto_close = true,
          focus = true,
        },
      },
    },
  },
  {
    'RRethy/vim-illuminate',
    opts = {
      providers = { 'lsp', 'regex' }, -- Prioritize LSP/Treesitter for accuracy
      delay = 20,
      filetypes_denylist = { 'dirvish', 'fugitive', 'NvimTree' },
      under_cursor = true,
      large_file_cutoff = 10000,
      large_file_overrides = nil,
      min_count_to_highlight = 1,
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      local function set_illuminate_hl()
        local pairs = {
          { 'IlluminatedWordText', 'LspReferenceText' },
          { 'IlluminatedWordRead', 'LspReferenceRead' },
          { 'IlluminatedWordWrite', 'LspReferenceWrite' },
        }
        for _, p in ipairs(pairs) do
          local hl = vim.api.nvim_get_hl(0, { name = p[2], link = false })
          hl.underline = true
          vim.api.nvim_set_hl(0, p[1], hl)
        end
      end
      set_illuminate_hl()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = set_illuminate_hl })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'nu',
        'python',
        'rust',
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'json',
        'yaml',
        'toml',
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { 'ruby', 'python', 'c' },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- Neovim 0.12 compat: node:range() can return nil during ranged parses
      -- (triggered by render-markdown on inline code spans). Wrap with pcall.
      local aliases = { ex = 'elixir', pl = 'perl', sh = 'bash', ts = 'typescript' }
      vim.treesitter.query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local node = match[pred[2]]
        if not node then return end
        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
        if not ok or not text then return end
        local alias = text:lower()
        metadata['injection.language'] = vim.filetype.match({ filename = 'a.' .. alias })
          or aliases[alias]
          or alias
      end, { force = true, all = false })
    end,
  },
}
