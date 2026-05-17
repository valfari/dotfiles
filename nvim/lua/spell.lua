vim.opt.spell = false
vim.opt.spelllang = 'en_gb'

-- Download spell files automatically if missing
-- vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'  -- Custom word list file

vim.keymap.set('n', '<leader>ts', function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify('Spell check: ' .. (vim.opt.spell:get() and 'enabled' or 'disabled'))
end, { desc = '[S]pell [C]heck' })

-- Enable only for specific filetypes via autocmd
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'markdown', 'text', 'tex', 'gitcommit' },  -- Add your filetypes here
--   callback = function()
--     vim.opt_local.spell = true
--   end,
-- })

vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, fg = 'Red' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, fg = 'Yellow' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, fg = 'Magenta' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, fg = 'Cyan' })

-- Keymaps for spell navigation and correction (built-in)
-- ]s: Next misspelled word
-- [s: Previous misspelled word
-- z=: Suggest corrections
-- zg: Add word to good list
-- zw: Add word to wrong list
-- zuw: Undo adding word
