return {
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
      'stevearc/conform.nvim',
      'b0o/SchemaStore.nvim',
    },

    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

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
          lsp_config.server_capabilities = nil
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
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', bufopts, { desc = 'Goto Definition' }))
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = 'Goto Declaration' }))
          vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, vim.tbl_extend('force', bufopts, { desc = 'Goto Type Definition' }))
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', bufopts, { desc = 'Goto Implementation' }))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', bufopts, { desc = 'Goto References' }))
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code Action' }))
          vim.keymap.set('n', '<leader>rnn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename' }))
          vim.keymap.set('n', 'gp', function()
            vim.cmd 'split'
            vim.lsp.buf.definition()
          end, vim.tbl_extend('force', bufopts, { desc = 'Peek Definition (split)' }))
          vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, vim.tbl_extend('force', bufopts, { desc = 'Prev Diagnostic' }))
          vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, vim.tbl_extend('force', bufopts, { desc = 'Next Diagnostic' }))
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Help' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Hover Documentation' }))

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

      vim.diagnostic.config { virtual_text = { current_line = true }, virtual_lines = false }

      vim.keymap.set('', '<leader>tl', function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = { current_line = true }, virtual_lines = false }
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
        lsp_format = 'fallback',
      },
      default_format_opts = { lsp_format = 'fallback' },
    },
  },
}
