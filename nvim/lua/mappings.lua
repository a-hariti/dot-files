local merge_tables = function(first, second)
  local all = {}
  for k, v in pairs(first) do
    all[k] = v
  end
  for k, v in pairs(second) do
    all[k] = v
  end
  return all
end

-- do global mappings
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

-- do buffer local mappings
local bmap = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, merge_tables(opts or {}, { buffer = 0 }))
end

local M = {}

vim.g.mapleader = ' '
map('n', "'", '`', { noremap = true })

map('n', 'J', 'mzJ`z')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

map('v', '<C-j>', ":m '>+1<CR>gv=gv")
map('v', '<C-k>', ":m '<-2<CR>gv=gv")

map('n', ']g', '<Plug>(GitGutterNextHunk)')
map('n', '[g', '<Plug>(GitGutterPrevHunk)')
map('n', '<leader>gg', ':Git<CR>')

map('n', '<leader>e', ':NvimTreeFindFile<cr>', { silent = true })

map('i', '<C-j>', 'copilot#Next()', { expr = true, script = true, replace_keycodes = false })
map('i', '<C-k>', 'copilot#Previous()', { expr = true, script = true, replace_keycodes = false })
map('i', '<C-l>', 'copilot#Accept("\\<CR>")', { expr = true, script = true, replace_keycodes = false })
map('i', '<C-x>', 'copilot#Dismiss()', { expr = true, script = true, replace_keycodes = false })

map('n', 'Q', '<nop>')

map('n', '<leader>w', ':update<CR>', { noremap = true })
map('n', '<leader>q', ':q<CR>', { noremap = true })
map('n', '<leader>x', ':cclose<CR>', { noremap = true })

map('n', '<leader><leader>', '<C-^>', { noremap = true })

map('v', '>', '>gv', { noremap = true })
map('v', '<', '<gv', { noremap = true })

map('n', '<M-up>', ':resize +1<CR>', { silent = true })
map('n', '<M-down>', ':resize -1<CR>', { silent = true })
map('n', '<M-left>', ':vertical resize -1<CR>', { silent = true, noremap = true })
map('n', '<M-right>', ':vertical resize +1<CR>', { silent = true, noremap = true })

map('n', '<leader>y', '"+y')
map('v', '<leader>y', '"+y')
map('v', '<leader>p', '"+p')

-- escape terminal mode
map('t', '<esc><esc>', '<c-\\><c-n>')

-- toggle fold
map('n', '<S-tab>', 'za')

-- get rid of annyoing serach highlight
map('n', '<esc>', ':noh<CR>')

-- unimpaired like mappings
map('n', '[<space>', ":call append(line('.')-1, '')<CR>", { silent = true })
map('n', ']<space>', ":call append(line('.'), '')<CR>", { silent = true })
map('n', '[a', ':previous<CR>')
map('n', ']a', ':next<CR>')
map('n', '[A', ':first<CR>')
map('n', ']A', ':last<CR>')
map('n', '[b', ':bp<CR>')
map('n', ']b', ':bn<CR>')
map('n', '[B', ':bf<CR>')
map('n', ']B', ':bl<CR>')
map('n', '[l', ':lp<CR>')
map('n', ']l', ':lne<CR>')
map('n', '[L', ':lfirst<CR>')
map('n', ']L', ':llast<CR>')
map('n', '[q', ':cp<CR>')
map('n', ']q', ':cn<CR>')
map('n', '[Q', ':cfirst<CR>')
map('n', ']Q', ':clast<CR>')

map({ 'n', 'v' }, '*', '<Plug>(asterisk-z*)')
map({ 'n', 'v' }, 'g*', '<Plug>(asterisk-gz*)')
map({ 'n', 'v' }, '#', '<Plug>(asterisk-z#)')
map({ 'n', 'v' }, 'g#', '<Plug>(asterisk-gz#)')

local ok, telescope = pcall(require, 'telescope.builtin')
if not ok then
  print('telescope.builtin not found')
  return
end
map('n', '<leader>ff', telescope.find_files)
map('n', '<leader>fs', telescope.lsp_document_symbols)
map('n', '<leader>fw', telescope.lsp_workspace_symbols)
map('n', '<leader>fg', telescope.live_grep)
map('n', '<leader>fl', telescope.current_buffer_fuzzy_find)
map('n', '<leader>b', telescope.buffers)
map('n', '<leader>tt', telescope.builtin)

-- Harpoon
local ok, harpoon_ui = pcall(require, 'harpoon.ui')
if ok then
  map('n', '<leader>hh', function()
    harpoon_ui.toggle_quick_menu()
  end)
  map('n', '<leader>m', function()
    require('harpoon.mark').add_file()
  end)
  map('n', '<leader>,', function()
    harpoon_ui.nav_prev()
  end)
  map('n', '<leader>.', function()
    harpoon_ui.nav_next()
  end)
  map('n', '<leader>ja', function()
    harpoon_ui.nav_file(1)
  end)
  map('n', '<leader>js', function()
    harpoon_ui.nav_file(2)
  end)
  map('n', '<leader>jd', function()
    harpoon_ui.nav_file(3)
  end)
  map('n', '<leader>jf', function()
    harpoon_ui.nav_file(4)
  end)
else
  print('harpoon not found')
end

map({ 'n', 'v' }, '<leader>s', function()
  vim.lsp.buf.format({ async = true })
end, { silent = true })

local lsp_organize_imports = function()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = '',
  }
  vim.lsp.buf.execute_command(params)
end

local function nav_diagnostic_errors(next_)
  return function()
    if next_ then
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    else
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end
  end
end

function M.lsp_mappings()
  bmap('n', '<C-]>', vim.lsp.buf.definition)
  bmap('n', '<leader>o', lsp_organize_imports)
  bmap('n', '<leader>gi', vim.lsp.buf.implementation)
  bmap('n', '<leader>gr', telescope.lsp_references)
  bmap('n', '<leader>gn', vim.lsp.buf.rename)
  bmap('n', '<leader>k', vim.lsp.buf.hover)
  bmap('n', '<leader>ca', vim.lsp.buf.code_action)
  bmap('n', ']e', nav_diagnostic_errors(true))
  bmap('n', '[e', nav_diagnostic_errors(false))
  bmap('n', ']d', vim.diagnostic.goto_next)
  bmap('n', '[d', vim.diagnostic.goto_prev)
end

return M
