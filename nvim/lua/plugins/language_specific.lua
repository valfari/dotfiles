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
    -- inline image output; disable if images don't render correctly over wezterm's kitty protocol
    '3rd/image.nvim',
    opts = {
      backend = 'kitty',
      processor = 'magick_cli',
    },
  },
  {
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    build = ':UpdateRemotePlugins',
    dependencies = { '3rd/image.nvim' },
    ft = { 'python', 'markdown', 'quarto' },
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_output_win_max_height = 12
    end,
    keys = {
      { '<leader>ji', ':MoltenInit<CR>', desc = 'Jupyter: init kernel' },
      { '<leader>jcp', ':MoltenInit databricks-connect<CR>', desc = 'Jupyter: init Databricks Connect kernel (personal cluster, default)' },
      { '<leader>jca', ':MoltenInit databricks-connect-164<CR>', desc = 'Jupyter: init Databricks Connect kernel (ADHOC-16-4, parked)' },
      { '<leader>jch', ':MoltenInit databricks-connect-heavy<CR>', desc = 'Jupyter: init Databricks Connect kernel (heavy computation)' },
      { '<leader>je', ':MoltenEvaluateOperator<CR>', desc = 'Jupyter: evaluate operator' },
      { '<leader>jr', ':MoltenReevaluateCell<CR>', desc = 'Jupyter: re-evaluate cell' },
      { '<leader>jl', ':MoltenEvaluateLine<CR>', desc = 'Jupyter: evaluate line' },
      { '<leader>je', ':<C-u>MoltenEvaluateVisual<CR>gv', mode = 'v', desc = 'Jupyter: evaluate selection' },
      { '<leader>jo', ':MoltenShowOutput<CR>', desc = 'Jupyter: show output' },
      { '<leader>jd', ':MoltenDelete<CR>', desc = 'Jupyter: delete cell output' },
    },
  },
  {
    -- fork of GCBallesteros/jupytext.nvim, which is unmaintained (last commit 2024-04);
    -- this fork carries ongoing fixes (buffer-write hooks, duplicate-open handling)
    '5ayam5/jupytext.nvim',
    opts = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },
  {
    'quarto-dev/quarto-nvim',
    ft = { 'markdown', 'quarto' },
    dependencies = { 'jmbuhr/otter.nvim' },
    opts = {
      lspFeatures = {
        languages = { 'python' },
        -- 'curly' (quarto-nvim's default) only matches ```{python} chunks; jupytext emits plain
        -- ```python fences, so this must be anything else to fall back to the standard treesitter
        -- markdown injections query
        chunks = 'all',
        diagnostics = { enabled = true, triggers = { 'BufWritePost' } },
        completion = { enabled = true },
      },
      codeRunner = {
        enabled = true,
        default_method = 'molten',
      },
    },
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

      metals_config.on_attach = function(_, bufnr)
        require('lsp_keymaps').setup(bufnr)
      end

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
