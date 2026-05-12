return {
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
    main = 'nvim-treesitter.configs',
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
  },
}
