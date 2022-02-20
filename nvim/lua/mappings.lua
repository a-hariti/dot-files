local map = function(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {})
end

-- do buffer local mappings
local bmap = function(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts or {})
end

local M = {}

vim.g.mapleader = " "
map("n", "'", "`", {noremap = true})
map("n", "]h", "<Plug>(GitGutterNextHunk)")
map("n", "[h", "<Plug>(GitGutterPrevHunk)")
map("n", "<leader>e", ':lua require"nvim-tree".toggle(false, true)<cr>', {noremap = true})

map("n", "Q", ":q<cr>")

map("n", "<leader>d", ":Format<cr>")
map("n", "<leader>v", ":e $MYVIMRC<CR>", {noremap = true})

map("n", "<leader>w", ":update<CR>", {noremap = true})
map("n", "<leader>q", ":q<CR>", {noremap = true})

map("n", "<leader><leader>", "<C-^>", {noremap = true})

map("v", ">", ">gv", {noremap = true})
map("v", "<", "<gv", {noremap = true})

map("n", "<M-up>", ":resize +1<CR>", {silent = true})
map("n", "<M-down>", ":resize -1<CR>", {silent = true})
map("n", "<M-left>", ":vertical resize -1<CR>", {silent = true, noremap = true})
map("n", "<M-right>", ":vertical resize +1<CR>", {silent = true, noremap = true})

map("n", "<leader>p", '"+p')
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("v", "<leader>p", '"+p')

-- escape terminal mode
map("t", "<esc><esc>", "<c-\\><c-n>")

-- toggle fold
map("n", "<S-tab>", "za")

-- get rid of annyoing serach highlight
map("n", "<esc>", ":noh<CR>")

-- unimpaired like mappings
map("n", "[<space>", ":call append(line('.')-1, '')<CR>", {silent = true})
map("n", "]<space>", ":call append(line('.'), '')<CR>", {silent = true})
map("n", "[a", ":previous<CR>")
map("n", "]a", ":next<CR>")
map("n", "[A", ":first<CR>")
map("n", "]A", ":last<CR>")
map("n", "[b", ":bp<CR>")
map("n", "]b", ":bn<CR>")
map("n", "[B", ":bf<CR>")
map("n", "]B", ":bl<CR>")
map("n", "[l", ":lp<CR>")
map("n", "]l", ":lne<CR>")
map("n", "[L", ":lfirst<CR>")
map("n", "]L", ":llast<CR>")
map("n", "[q", ":cp<CR>")
map("n", "]q", ":cn<CR>")
map("n", "[Q", ":cfirst<CR>")
map("n", "]Q", ":clast<CR>")

for _, mode in ipairs({"n", "v"}) do
  map(mode, "*", "<Plug>(asterisk-z*)")
  map(mode, "g*", "<Plug>(asterisk-gz*)")
  map(mode, "#", "<Plug>(asterisk-z#)")
  map(mode, "g#", "<Plug>(asterisk-gz#)")
end

map("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<CR>")
map("n", "<leader>fb", ":lua require('telescope.builtin').buffers()<CR>")
map("n", "<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>")
map("n", "<leader>fc", ":lua require('telescope.builtin').git_commits()<CR>")
map("n", "<leader>ft", ":lua require('telescope.builtin').builtin()<CR>")

function M.lsp_mappings()
  bmap("n", "<C-]>", ":lua vim.lsp.buf.definition()<CR>")
  bmap("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
  bmap("n", "<leader>sh", ":lua vim.lsp.buf.signature_help()<CR>")
  bmap("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>")
  bmap("n", "<leader>gn", ":lua vim.lsp.buf.rename()<CR>")
  bmap("n", "<leader>k", ":lua vim.lsp.buf.hover()<CR>")
  bmap("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>")
  bmap("n", "<leader>gg", ":lua vim.lsp.util.show_line_diagnostics()<CR>")
  bmap("n", "]g", ":lua vim.lsp.diagnostic.goto_next()<CR>")
  bmap("n", "[g", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
  bmap("n", "<leader>a", ":lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>", {silent = true})
end

return M
