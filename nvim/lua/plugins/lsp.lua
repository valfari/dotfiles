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

      -- Walk up from root_dir looking for a virtualenv, so nested Python
      -- projects (e.g. a template/fixture dir with its own pyproject.toml
      -- but no venv of its own) still resolve imports via an ancestor venv.
      local function find_ancestor_venv_python(root_dir)
        local dir = root_dir
        for _ = 1, 8 do
          for _, venv_name in ipairs { '.venv', 'venv' } do
            local python = dir .. '/' .. venv_name .. '/bin/python'
            if vim.uv.fs_stat(python) then
              return python
            end
          end
          local parent = vim.fs.dirname(dir)
          if parent == dir then
            break
          end
          dir = parent
        end
        return nil
      end

      local servers = {
        bashls = true,
        lua_ls = {
          cmd = { 'lua-language-server' },
        },
        rust_analyzer = true,
        kotlin_lsp = {
          -- Mason's kotlin-lsp package installs the JetBrains binary as
          -- `intellij-server`, not the `kotlin-lsp` nvim-lspconfig defaults to.
          cmd = { 'intellij-server', '--stdio' },
        },
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
                  reportUnusedVariable = 'hint',
                  reportUnusedImport = 'hint',
                  reportUnusedFunction = 'hint',
                  reportUnusedClass = 'hint',
                },
                typeCheckingMode = 'standard',
                useLibraryCodeForTypes = true,
              },
            },
          },
          on_init = function(client)
            local python_path = find_ancestor_venv_python(client.root_dir)
            if python_path then
              client.settings = vim.tbl_deep_extend('force', client.settings or {}, {
                python = { pythonPath = python_path },
              })
              client.config.settings = client.settings
            end
          end,
        },
        ruff = { manual_install = true },
        -- Not mason-managed: mason recreates a package's venv on
        -- reinstall/update, which would silently drop the manually
        -- pip-installed pylsp-rope plugin. Uses the same tools venv already
        -- referenced by python3_host_prog in init.lua.
        pylsp = {
          manual_install = true,
          cmd = { '/Users/vustimenko/Code/installs/venvs/.venv/bin/pylsp' },
          settings = {
            pylsp = {
              plugins = {
                -- disable everything that would otherwise duplicate
                -- basedpyright/ruff/blink.cmp
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                pyls_isort = { enabled = false },
                rope_completion = { enabled = false },
                jedi_completion = { enabled = false },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = false },
                jedi_symbols = { enabled = false },
                jedi_definition = { enabled = false },
                jedi_signature_help = { enabled = false },
                rope_autoimport = { enabled = false }, -- unreliable (posix vs os, misses numpy.ndarray)
                pylsp_rope = { enabled = true },
              },
            },
          },
          -- pylsp advertises these structurally regardless of which plugins
          -- are enabled server-side; strip them client-side so it never
          -- competes with basedpyright/blink.cmp for anything but code
          -- actions and commands (extract variable/method, introduce
          -- parameter, generate, organize imports).
          server_capabilities = {
            hoverProvider = false,
            definitionProvider = false,
            declarationProvider = false,
            typeDefinitionProvider = false,
            implementationProvider = false,
            referencesProvider = false,
            documentSymbolProvider = false,
            workspaceSymbolProvider = false,
            documentFormattingProvider = false,
            documentRangeFormattingProvider = false,
            documentHighlightProvider = false,
            signatureHelpProvider = false,
            completionProvider = false,
            foldingRangeProvider = false,
            codeLensProvider = false,
            renameProvider = false,
          },
        },
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
        'prettier',
        'ktlint',
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

          require('lsp_keymaps').setup(bufnr)

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

      vim.keymap.set('', '<leader>tv', function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
          vim.notify 'Diagnostics: virtual lines'
        else
          vim.diagnostic.config { virtual_text = { current_line = true }, virtual_lines = false }
          vim.notify 'Diagnostics: virtual text'
        end
      end, { desc = '[V]irtual [L]ines' })
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
        json = { 'prettier' },
        kotlin = { 'ktlint' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      default_format_opts = { lsp_format = 'fallback' },
    },
  },
}
