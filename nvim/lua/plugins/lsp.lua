return {
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      ui = {
        border = 'rounded',
      },
      lightbulb = { enable = true },
      symbol_in_winbar = { enable = true },
    },
    config = function(_, opts)
      require('lspsaga').setup(opts)
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      {
        'folke/lazydev.nvim',
        ft = 'lua',
      },
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },
      'stevearc/conform.nvim',
      'b0o/SchemaStore.nvim',
    },

    config = function()
      local capabilities = nil
      if pcall(require, 'cmp_nvim_lsp') then
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      end

      local servers = {
        bashls = true,
        lua_ls = {
          cmd = { 'lua-language-server' },
        },
        rust_analyzer = true,
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                diagnosticSeverityOverrides = {
                  reportUnknownArgumentType = 'none',
                  reportUnknownParameterType = 'none',
                  reportUnknownVariableType = 'none',
                },
                typeCheckingMode = 'standard',
                useLibraryCodeForTypes = true,
                extraPaths = {
                  '/home/v/Code/work/forecast-store-product-feature-table-pipeline/__pypackages__/3.11/lib',
                  '/home/v/Code/work/dagster-common',
                },
              },
            },
          },
        },
        ruff = { manual_install = true },
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              -- schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      }
      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == 'table' then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require('mason').setup()
      local ensure_installed = {
        'stylua',
        'lua_ls',
        -- 'delve',
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Set global capabilities for all LSP servers
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Configure and enable each LSP server
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end

        -- Only call vim.lsp.config if there are server-specific settings
        if next(config) ~= nil then
          -- Remove manual_install flag as it's not an LSP config field
          local lsp_config = vim.tbl_deep_extend('force', {}, config)
          lsp_config.manual_install = nil
          vim.lsp.config(name, lsp_config)
        end

        vim.lsp.enable(name)
      end

      local disable_semantic_tokens = {
        -- lua = true,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')

          local settings = servers[client.name]
          if type(settings) ~= 'table' then
            settings = {}
          end

          vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
          local bufopts = { buffer = 0 }
          vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Definition' }))
          vim.keymap.set('n', 'gD', '<cmd>Lspsaga goto_declaration<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Declaration' }))
          vim.keymap.set('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Type Definition' }))
          vim.keymap.set('n', 'gi', '<cmd>Lspsaga finder imp<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Implementation' }))
          vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder ref<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto References' }))
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', vim.tbl_extend('force', bufopts, { desc = 'Code Action' }))

          vim.keymap.set('n', '<leader>rnn', '<cmd>Lspsaga rename<CR>', vim.tbl_extend('force', bufopts, { desc = 'Rename' }))
          vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Peek Definition' }))

          vim.keymap.set('n', '<leader>[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', bufopts)
          vim.keymap.set('n', '<leader>]d', '<cmd>Lspsaga diagnostic_jump_next<CR>', bufopts)

          vim.keymap.set('i', '<C-k>', '<cmd>Lspsaga signature_help<CR>', { buffer = bufnr, desc = 'Signature Help' })
          vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', vim.tbl_extend('force', bufopts, { desc = 'Hover Documentation' }))
          --
          -- local builtin = require 'telescope.builtin'
          --
          -- vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
          -- vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = 0 })
          -- vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = 0 })
          -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = 0 })
          -- vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { buffer = 0 })
          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
          --
          -- vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, { buffer = 0 })
          -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = 0 })
          -- vim.keymap.set('n', '<space>wd', builtin.lsp_document_symbols, { buffer = 0 })
          -- vim.keymap.set('n', '<space>ww', function()
          --   builtin.diagnostics { root_dir = true }
          -- end, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      require('lsp_lines').setup()
      vim.diagnostic.config { virtual_text = true, virtual_lines = false }

      vim.keymap.set('', '<leader>tl', function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = 'Toggle lsp_lines' })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format' },
        rust = { 'rustfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      default_format_opts = { lsp_fallback = true },
    },
  },
}
