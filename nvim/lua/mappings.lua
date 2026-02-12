-- do global mappings
local map = vim.keymap.set

map('n', "'", '`', { noremap = true })

map('n', 'J', 'mzJ`z')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

map('v', '<C-j>', ":m '>+1<CR>gv=gv")
map('v', '<C-k>', ":m '<-2<CR>gv=gv")

map('n', '<leader>gg', ':Git<CR>')

local function toggle_diagnostics()
  vim.diagnostic.enable(vim.diagnostic.is_enabled())
end
map('n', '<leader>dd', toggle_diagnostics, { desc = 'Toggle diagnostics display' })

local function toggle_conceal()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
end
map('n', '<leader>cc', toggle_conceal, { desc = 'Toggle conceal' })

local function toggle_inlay_hints()
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
end
map('n', '<leader>h', toggle_inlay_hints, { desc = 'Toggle inlay hints' })

map('n', 'Q', '<nop>')

map('n', '<leader>w', ':update<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>x', ':cclose<CR>')

map('n', '<leader><leader>', '<C-^>')

map('v', '>', '>gv')
map('v', '<', '<gv')

map('n', '<M-up>', ':resize +1<CR>', { silent = true })
map('n', '<M-down>', ':resize -1<CR>', { silent = true })
map('n', '<M-left>', ':vertical resize -1<CR>', { silent = true })
map('n', '<M-right>', ':vertical resize +1<CR>', { silent = true })

map({ 'n', 'v' }, '<leader>p', '"+p')

-- escape terminal mode
map('t', '<esc><esc>', '<c-\\><c-n>')

-- resolve ambiguity of :G
vim.cmd('cabbrev G Git')

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
