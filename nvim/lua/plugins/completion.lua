return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = {},
      },
      'Kaiser-Yang/blink-cmp-dictionary',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<S-CR>'] = { 'select_and_accept', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = function()
          if vim.tbl_contains({ 'markdown', 'text', 'gitcommit', 'quarto' }, vim.bo.filetype) then
            return { 'dictionary', 'lsp', 'path', 'snippets', 'buffer' }
          end
          return { 'lsp', 'path', 'snippets', 'buffer' }
        end,
        providers = {
          dictionary = {
            module = 'blink-cmp-dictionary',
            name = 'Dict',
            min_keyword_length = 3,
            opts = {
              dictionary_files = { vim.fn.expand '/usr/share/dict/words' },
              max_items = 8,
            },
          },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust' },
      signature = { enabled = true },
    },
  },
}
