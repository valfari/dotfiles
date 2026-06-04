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

-- LINE MOVE
vim.keymap.set('n', '<A-Down>', '<cmd>move .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-Up>', '<cmd>move .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('x', '<A-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('x', '<A-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- COMMENT (native Neovim 0.10+ gc/gb operators)
local _comment_type = 'block'
vim.keymap.set({ 'n', 'x' }, '<leader>tc', function()
  _comment_type = _comment_type == 'line' and 'block' or 'line'
  vim.notify('Comment type: ' .. _comment_type)
  return _comment_type == 'line' and 'gc' or 'gb'
end, { expr = true, remap = true, desc = '[C]omment [T]ype' })

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
end, { desc = '[D]iff vs [C]lipboard' })

vim.cmd 'packadd nvim.undotree'
vim.cmd 'packadd nvim.difftool'
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<CR>', { desc = 'Toggle Undotree' })

-- COPY PATH
local function get_current_path(full)
  if vim.bo.filetype == 'oil' then
    local oil = require 'oil'
    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if entry and dir then
      return full and (dir .. entry.name) or entry.name
    end
  else
    return full and vim.fn.expand '%:p' or vim.fn.expand '%:t'
  end
end

vim.keymap.set('n', '<leader>yp', function()
  local path = get_current_path(true)
  if path and path ~= '' then
    vim.fn.setreg('+', path)
    vim.notify('Copied: ' .. path)
  end
end, { desc = '[Y]ank [P]ath' })

vim.keymap.set('n', '<leader>yf', function()
  local name = get_current_path(false)
  if name and name ~= '' then
    vim.fn.setreg('+', name)
    vim.notify('Copied: ' .. name)
  end
end, { desc = '[Y]ank [F]ilename' })

vim.keymap.set('n', '<leader>ya', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')
  vim.fn.setreg('+', content)
  vim.notify 'Copied buffer contents'
end, { desc = '[Y]ank [A]ll' })

-- EXECUTE COMMANDS
vim.keymap.set('v', '<leader>el', ':lua<CR>', { desc = '[E]xecute [L]ua' })
--
-- TOGGLE COMMANDS

local themes = {
  { scheme = 'gruvbox', bg = 'dark', label = 'gruvbox dark' },

  { scheme = 'everforest', bg = 'dark', label = 'everforest' },
  { scheme = 'catppuccin-frappe', bg = 'dark', label = 'catppuccin-frappe' },
  { scheme = 'tokyonight-night', bg = 'dark', label = 'tokyonight-night' },
  { scheme = 'kanagawa-wave', bg = 'dark', label = 'kanagawa-wave' },
}
local current_theme_index = 1

local theme_state_file = vim.fn.stdpath 'data' .. '/theme_per_cwd.json'

local function save_theme_for_cwd()
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(theme_state_file), ''))
  end)
  local map = (ok and type(data) == 'table') and data or {}
  map[vim.fn.getcwd()] = current_theme_index
  vim.fn.writefile({ vim.json.encode(map) }, theme_state_file)
end

local function restore_theme_for_cwd()
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(theme_state_file), ''))
  end)
  if not ok or type(data) ~= 'table' then
    return
  end
  local idx = data[vim.fn.getcwd()]
  if idx and themes[idx] then
    current_theme_index = idx
    local t = themes[idx]
    vim.o.background = t.bg
    vim.cmd.colorscheme(t.scheme)
  end
end

local function apply_theme(t)
  vim.o.background = t.bg
  vim.cmd.colorscheme(t.scheme)
  print('Switched to ' .. t.label)
  save_theme_for_cwd()
end
_G._theme_toggle_next = function()
  current_theme_index = current_theme_index % #themes + 1
  apply_theme(themes[current_theme_index])
end
_G._theme_toggle_prev = function()
  current_theme_index = (current_theme_index - 2) % #themes + 1
  apply_theme(themes[current_theme_index])
end
vim.keymap.set('n', '<leader>tu', function()
  vim.go.operatorfunc = 'v:lua._theme_toggle_next'
  return 'g@l'
end, { expr = true, desc = '[UI] theme' })

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = restore_theme_for_cwd,
})

-- DIFF ALGORITHM TOGGLE
local diff_algorithms = { 'myers', 'patience', 'histogram' }
local diff_algo_index = 3 -- start at histogram
_G._diff_algo_toggle = function()
  diff_algo_index = diff_algo_index % #diff_algorithms + 1
  local algo = diff_algorithms[diff_algo_index]
  vim.opt.diffopt:remove(vim.tbl_map(function(a)
    return 'algorithm:' .. a
  end, diff_algorithms))
  vim.opt.diffopt:append('algorithm:' .. algo)
  vim.notify('Diff algorithm: ' .. algo)
end
vim.keymap.set('n', '<leader>dt', function()
  vim.go.operatorfunc = 'v:lua._diff_algo_toggle'
  return 'g@l'
end, { expr = true, desc = '[D]iff algorithm [T]oggle' })

-- HANDLE DATAPROC
vim.keymap.set('n', '<leader>hp', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local raw = table.concat(lines, '\n')

  local ok, outer = pcall(vim.json.decode, raw)
  if not ok or type(outer) ~= 'table' or type(outer.message) ~= 'string' then
    vim.notify('hdp: could not parse buffer as log JSON', vim.log.levels.ERROR)
    return
  end

  local msg = outer.message
  local req_start = msg:find('request=', 1, true)
  if not req_start then
    vim.notify('hdp: no request= found in message', vim.log.levels.ERROR)
    return
  end
  local json_str = msg:sub(req_start + #'request=')

  local resp_start = json_str:find(' ; response=', 1, true)
  if resp_start then
    json_str = json_str:sub(1, resp_start - 1)
  end

  local ok2, payload = pcall(vim.json.decode, json_str)
  if not ok2 or type(payload) ~= 'table' then
    vim.notify('hdp: could not parse request JSON', vim.log.levels.ERROR)
    return
  end

  payload.tags = nil

  local compact = vim.json.encode(payload)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { compact })
  vim.bo.filetype = 'json'

  require('conform').format { async = false, timeout_ms = 2000 }
  vim.notify 'hdp: dataproc payload extracted'
end, { desc = '[H]andle [D]ata[P]roc payload' })

-- HANDLE JAR
vim.keymap.set('n', '<leader>hj', function()
  local jar_url = vim.trim(vim.fn.getreg '+')
  if jar_url == '' then
    vim.notify('hj: clipboard is empty', vim.log.levels.ERROR)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local replaced = false
  for i, line in ipairs(lines) do
    if line:find('"main_application_file"', 1, true) then
      local indent = line:match '^(%s*)'
      local trailing_comma = line:match ',$' and ',' or ''
      lines[i] = indent .. '"main_application_file": "' .. jar_url .. '"' .. trailing_comma
      replaced = true
      break
    end
  end

  if not replaced then
    vim.notify('hj: main_application_file not found in buffer', vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.notify 'hj: main_application_file updated'
end, { desc = '[H]andle [J]ar url' })

-- HANDLE JAR (BULK)
vim.keymap.set('n', '<leader>hJ', function()
  if vim.bo.filetype ~= 'oil' then
    vim.notify('hJ: must be run from an oil buffer', vim.log.levels.ERROR)
    return
  end

  local jar_url = vim.trim(vim.fn.getreg '+')
  if jar_url == '' then
    vim.notify('hJ: clipboard is empty', vim.log.levels.ERROR)
    return
  end

  local dir = require('oil').get_current_dir()
  if not dir then
    vim.notify('hJ: could not get current directory', vim.log.levels.ERROR)
    return
  end

  local json_files = vim.fn.glob(dir .. '*.json', false, true)
  if #json_files == 0 then
    vim.notify('hJ: no JSON files in ' .. dir, vim.log.levels.WARN)
    return
  end

  local updated, skipped = 0, 0
  for _, path in ipairs(json_files) do
    local lines = vim.fn.readfile(path)
    local replaced = false
    for i, line in ipairs(lines) do
      if line:find('"main_application_file"', 1, true) then
        local indent = line:match '^(%s*)'
        local trailing_comma = line:match ',$' and ',' or ''
        lines[i] = indent .. '"main_application_file": "' .. jar_url .. '"' .. trailing_comma
        replaced = true
        break
      end
    end
    if replaced then
      vim.fn.writefile(lines, path)
      updated = updated + 1
    else
      skipped = skipped + 1
    end
  end

  vim.notify(string.format('hJ: updated %d, skipped %d', updated, skipped))
end, { desc = '[H]andle [J]ar url (bulk)' })

-- MOVE TO PROJECT ROOT
vim.keymap.set('n', '<leader>mp', function()
  local root = vim.fs.root(0, { '.git', 'Cargo.toml', 'pyproject.toml', 'package.json', 'go.mod' })
  if root then
    require('oil').open(root)
  else
    vim.notify('No project root found', vim.log.levels.WARN)
  end
end, { desc = '[M]ove to [P]roject root' })
