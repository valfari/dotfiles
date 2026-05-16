local M = {}

local mode_labels = {
  n = 'NORMAL',  i = 'INSERT',  v = 'VISUAL',  V = 'V-LINE',
  ['\22'] = 'V-BLOCK',  c = 'COMMAND',  R = 'REPLACE',  r = 'REPLACE',
  s = 'SELECT',  S = 'S-LINE',  t = 'TERMINAL',
}

local mode_hls = {
  n = 'StatusLineModeN',  i = 'StatusLineModeI',
  v = 'StatusLineModeV',  V = 'StatusLineModeV',  ['\22'] = 'StatusLineModeV',
  c = 'StatusLineModeC',  R = 'StatusLineModeR',  r = 'StatusLineModeR',
  s = 'StatusLineModeV',  S = 'StatusLineModeV',  t = 'StatusLineModeN',
}

local home = os.getenv('HOME') or ''
local work_prefix = home .. '/Code/work/'

local function filepath()
  local path
  if vim.bo.filetype == 'oil' then
    local ok, oil = pcall(require, 'oil')
    path = ok and oil.get_current_dir() or vim.fn.expand('%:p')
  else
    path = vim.fn.expand('%:p')
  end
  if not path or path == '' then return '[No Name]' end
  if home ~= '' and path:sub(1, #work_prefix) == work_prefix then
    return path:sub(#work_prefix + 1)
  end
  if home ~= '' and path:sub(1, #home) == home then
    return '~' .. path:sub(#home + 1)
  end
  return path
end

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'StatusLineModeN', { fg = '#1d2021', bg = '#a9b665', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineModeI', { fg = '#1d2021', bg = '#7daea3', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineModeV', { fg = '#1d2021', bg = '#d8a657', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineModeR', { fg = '#1d2021', bg = '#ea6962', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineModeC', { fg = '#1d2021', bg = '#d3869b', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineGit',   { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'StatusLineDiagE', { link = 'DiagnosticError' })
  vim.api.nvim_set_hl(0, 'StatusLineDiagW', { link = 'DiagnosticWarn' })
  vim.api.nvim_set_hl(0, 'StatusLineMacro', { fg = '#d8a657', bold = true })
end

function M.render()
  local mode = vim.fn.mode()
  local hl   = mode_hls[mode] or 'StatusLineModeN'
  local label = mode_labels[mode] or mode:upper()
  local parts = {}

  -- Mode pill
  table.insert(parts, '%#' .. hl .. '# ' .. label .. ' %#StatusLine# ')

  -- Git branch + diff
  local branch = vim.b.gitsigns_head
  if branch and branch ~= '' then
    local status = vim.b.gitsigns_status
    local git_str = ' ' .. branch
    if status and status ~= '' then git_str = git_str .. '  ' .. status end
    table.insert(parts, '%#StatusLineGit#' .. git_str .. '%#StatusLine#  ')
  end

  -- Filename + modified/readonly
  table.insert(parts, filepath() .. '%m%r ')

  -- LSP diagnostics
  local counts = vim.diagnostic.count(0)
  local e = counts[vim.diagnostic.severity.ERROR] or 0
  local w = counts[vim.diagnostic.severity.WARN]  or 0
  if e > 0 then table.insert(parts, ' %#StatusLineDiagE# E:' .. e .. '%#StatusLine#') end
  if w > 0 then table.insert(parts, ' %#StatusLineDiagW# W:' .. w .. '%#StatusLine#') end

  -- Macro recording
  local reg = vim.fn.reg_recording()
  if reg ~= '' then
    table.insert(parts, '  %#StatusLineMacro#@' .. reg .. '%#StatusLine#')
  end

  -- Search count (cached, no recompute overhead)
  local ok, sc = pcall(vim.fn.searchcount, { recompute = false })
  if ok and sc and sc.active and (sc.total or 0) > 0 then
    table.insert(parts, '  ' .. sc.current .. '/' .. sc.total)
  end

  -- Right side
  table.insert(parts, '%=')
  table.insert(parts, '%{&filetype}  %l:%c  %p%% ')

  return table.concat(parts)
end

setup_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('StatusLineHl', { clear = true }),
  callback = setup_highlights,
})

_G._statusline_render = M.render
vim.o.statusline = '%!v:lua._statusline_render()'

return M
