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

map('n', ']h', '<Plug>(GitGutterNextHunk)')
map('n', '[h', '<Plug>(GitGutterPrevHunk)')

map('n', '<leader>e', ':if &filetype == "nerdtree" || &filetype == "" | :NERDTreeToggle | else | :NERDTreeFind | endif <CR>', {silent = true})

map('i', '<C-j>', 'copilot#Next()', { expr = true, script = true })
map('i', '<C-k>', 'copilot#Previous()', { expr = true, script = true })
map('i', '<C-l>', 'copilot#Accept("")', { expr = true, script = true })

map('n', 'Q', ':q<cr>')

map('n', '<leader>v', ':e $MYVIMRC<CR>', { noremap = true })

map('n', '<leader>w', ':update<CR>', { noremap = true })
map('n', '<leader>q', ':q<CR>', { noremap = true })

map('n', '<leader><leader>', '<C-^>', { noremap = true })

map('v', '>', '>gv', { noremap = true })
map('v', '<', '<gv', { noremap = true })

map('n', '<M-up>', ':resize +1<CR>', { silent = true })
map('n', '<M-down>', ':resize -1<CR>', { silent = true })
map('n', '<M-left>', ':vertical resize -1<CR>', { silent = true, noremap = true })
map('n', '<M-right>', ':vertical resize +1<CR>', { silent = true, noremap = true })

map('n', '<leader>p', '"+p')
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

local telescope = require('telescope.builtin')
map('n', '<leader>f', telescope.find_files)
map('n', '<leader>b', telescope.buffers)
map('n', '<leader>g', telescope.live_grep)
map('n', '<leader>tc', telescope.git_commits)
map('n', '<leader>tt', telescope.builtin)

function M.lsp_mappings()
  local lsp = vim.lsp
  bmap('n', '<C-]>', lsp.buf.definition)
  bmap('n', '<leader>gi', lsp.buf.implementation)
  bmap('n', '<leader>sh', lsp.buf.signature_help)
  bmap('n', '<leader>gr', telescope.lsp_references)
  bmap('n', '<leader>gn', lsp.buf.rename)
  bmap('n', '<leader>k', lsp.buf.hover)
  bmap('n', '<leader>ca', telescope.lsp_code_actions)
  bmap('n', ']g', lsp.diagnostic.goto_next)
  bmap('n', '[g', lsp.diagnostic.goto_prev)
  map('n', '<leader>d', telescope.diagnostics)
  bmap('n', '<leader>s', function()
    lsp.buf.formatting(nil, 1000)
  end)
end
return M
