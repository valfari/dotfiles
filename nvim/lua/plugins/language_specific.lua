return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'lervag/vimtex',
    enabled = false,
    ft = { 'tex', 'latex', 'plaintex' },
    init = function()
      -- Basic config goes here (see below)
    end,
  },
  {
    'benlubas/molten-nvim',
    enabled = false,
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    build = ':UpdateRemotePlugins',
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
    end,
  },
  {
    'scalameta/nvim-metals',
    ft = { 'scala', 'sbt', 'java' },
    opts = function()
      local metals_config = require('metals').bare_config()

      -- nvim-metals bypasses vim.lsp.config('*',...) so capabilities must be
      -- set directly here or blink.cmp completion won't work with metals
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()

      -- routes build status through window/showMessage → fidget.nvim picks it up
      metals_config.init_options = { statusBarProvider = 'on' }

      metals_config.settings = {
        showUnusedImports = true,
        showInferredType = true,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        enableSemanticHighlighting = true,
        superMethodLensesEnabled = true,
        testUserInterface = 'Code Lenses',
      }

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
