vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move"<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- WINDOW RESIZE
vim.keymap.set('n', '<A-k>', '<cmd>resize +10<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<A-j>', '<cmd>resize -10<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<A-l>', '<cmd>vertical resize +10<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<A-h>', '<cmd>vertical resize -10<CR>', { desc = 'Decrease window width' })

-- COMMENT (native Neovim 0.10+ gc/gb operators)
vim.keymap.set({ 'n', 'x' }, '<leader>tcl', 'gc', { remap = true, desc = '[T]oggle [C]omment [L]ine' })
vim.keymap.set({ 'n', 'x' }, '<leader>tcb', 'gb', { remap = true, desc = '[T]oggle [C]omment [B]lock' })

-- DIFF VS CLIPBOARD
vim.keymap.set('n', '<leader>dc', function()
  local clip = vim.split(vim.fn.getreg '+', '\n')
  local ft = vim.bo.filetype
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = ft
  vim.api.nvim_buf_set_name(buf, '[Clipboard]')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, clip)
  vim.cmd 'leftabove vsplit'
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd 'diffthis'
  vim.cmd 'wincmd p'
  vim.cmd 'diffthis'
end, { desc = 'Diff vs clipboard' })

vim.cmd('packadd nvim.undotree')
vim.cmd('packadd nvim.difftool')
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<CR>', { desc = 'Toggle Undotree' })

-- COPY PATH
vim.keymap.set('n', '<leader>y', function()
  local path
  if vim.bo.filetype == 'oil' then
    local oil = require('oil')
    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if entry and dir then
      path = dir .. entry.name
    end
  else
    path = vim.fn.expand('%:p')
  end
  if path and path ~= '' then
    vim.fn.setreg('+', path)
    vim.notify('Copied: ' .. path)
  end
end, { desc = 'Copy absolute path' })

-- EXECUTE COMMANDS
vim.keymap.set('v', '<leader>el', ':lua<CR>', { desc = '[E]xecute [L]ua' })
--
-- TOGGLE COMMANDS

local themes = {
  { scheme = 'gruvbox', bg = 'dark', label = 'gruvbox dark' },
  { scheme = 'gruvbox', bg = 'light', label = 'gruvbox light' },
  { scheme = 'everforest', bg = 'dark', label = 'everforest' },
  { scheme = 'catppuccin-frappe', bg = 'dark', label = 'catppuccin-frappe' },
  { scheme = 'tokyonight-night', bg = 'dark', label = 'tokyonight-night' },
  { scheme = 'kanagawa-wave', bg = 'dark', label = 'kanagawa-wave' },
  { scheme = 'rose-pine', bg = 'dark', label = 'rose-pine' },
  { scheme = 'nightfox', bg = 'dark', label = 'nightfox' },
  { scheme = 'onedark', bg = 'dark', label = 'onedark' },
}
local current_theme_index = 1
local function apply_theme(t)
  vim.o.background = t.bg
  vim.cmd.colorscheme(t.scheme)
  print('Switched to ' .. t.label)
end
vim.keymap.set('n', '<leader>ty', function()
  current_theme_index = current_theme_index % #themes + 1
  apply_theme(themes[current_theme_index])
end, { desc = 'Toggle theme next' })
vim.keymap.set('n', '<leader>tY', function()
  current_theme_index = (current_theme_index - 2) % #themes + 1
  apply_theme(themes[current_theme_index])
end, { desc = 'Toggle theme prev' })
