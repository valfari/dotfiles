vim.opt.spell = false
vim.opt.spelllang = 'en_gb'
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/en_gb.utf-8.add' -- Custom word list file, tracked in dotfiles

vim.keymap.set('n', '<leader>ts', function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify('Spell check: ' .. (vim.opt.spell:get() and 'enabled' or 'disabled'))
end, { desc = '[S]pell [C]heck' })

-- Enable only for prose filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit', 'quarto' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- On-demand autocorrect: jump to the nearest misspelled word, take the top
-- suggestion, then resume typing where you were
vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { desc = 'Fix nearest misspelled word (top suggestion)' })

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
