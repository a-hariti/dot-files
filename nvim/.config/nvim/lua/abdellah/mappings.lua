-- do global mappings
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

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
map({ 'n', 'v' }, '<leader>p', '"+p')

-- escape terminal mode
map('t', '<esc><esc>', '<c-\\><c-n>')

-- toggle fold
map('n', '<leader>z', 'za')

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
map('n', '<leader>ff', function()
  telescope.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
end)
map('n', '<leader>fs', telescope.lsp_document_symbols)
map('n', '<leader>fw', telescope.lsp_workspace_symbols)
map('n', '<leader>fg', telescope.live_grep)
map('n', '<leader>fl', telescope.current_buffer_fuzzy_find)
map('n', '<leader>b', telescope.buffers)
map('n', '<leader>tt', telescope.builtin)

-- other file
map('n', '<leader>o', ':Other<CR>')

-- Harpoon
local harpoon_ui = require('harpoon.ui')

map('n', '<leader>0', function()
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
map('n', '<leader>1', function()
  harpoon_ui.nav_file(1)
end)
map('n', '<leader>2', function()
  harpoon_ui.nav_file(2)
end)
map('n', '<leader>3', function()
  harpoon_ui.nav_file(3)
end)
map('n', '<leader>4', function()
  harpoon_ui.nav_file(4)
end)
