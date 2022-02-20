local map = function(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {})
end

vim.g.mapleader=' '
map("n", "'", "`", {noremap = true})
map("n", "]h", "<Plug>(GitGutterNextHunk)", {noremap = true})
map("n", "[h", "<Plug>(GitGutterPrevHunk)", {noremap = true})

map("n", "<C-]>",      ":lua vim.lsp.buf.definition()<CR>")
map("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
map("n", "<leader>sh", ":lua vim.lsp.buf.signature_help()<CR>")
map("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>")
map("n", "<leader>gn", ":lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>k",  ":lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>gg", ":lua vim.lsp.util.show_line_diagnostics()<CR>")
map("n", "]g",         ":lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "[g",         ":lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<leader>a",  ":lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>", {silent = true})

map("n", "<leader>d",  ":Format<cr>")
map("n", "<leader>v", ":e $MYVIMRC<CR>", {noremap = true})

map("n", "<leader>w", ":update<CR>", {noremap = true})
map("n", "<leader>q", ":q<CR>", {noremap = true})

map("n", "<leader><leader>", "<C-^>", {noremap = true})

map("v", ">", ">gv", {noremap = true})
map("v", "<", "<gv", {noremap = true})

map("n", "<silent>", "<M-up>    :resize +1<CR>")
map("n", "<silent>", "<M-down>  :resize -1<CR>")
map("n", "<silent>", "<M-left>  :vertical resize -1<CR>")
map("n", "<silent>", "<M-right> :vertical resize +1<CR>")

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
map("n", "[<space>", ":call append(line('.')-1, '')<CR>", {silent = ture})
map("n", "]<space>", ":call append(line('.'), '')<CR>", {silent = ture})
map("n", "[a",       ":previous<CR>")
map("n", "]a",       ":next<CR>")
map("n", "[A",       ":first<CR>")
map("n", "]A",       ":last<CR>")
map("n", "[b",       ":bp<CR>")
map("n", "]b",       ":bn<CR>")
map("n", "[B",       ":bf<CR>")
map("n", "]B",       ":bl<CR>")
map("n", "[l",       ":lp<CR>")
map("n", "]l",       ":lne<CR>")
map("n", "[L",       ":lfirst<CR>")
map("n", "]L",       ":llast<CR>")
map("n", "[q",       ":cp<CR>")
map("n", "]q",       ":cn<CR>")
map("n", "[Q",       ":cfirst<CR>")
map("n", "]Q",       ":clast<CR>")

map("n", "*",  "<Plug>(asterisk-z*)")
map("n", "g*", "<Plug>(asterisk-gz*)")
map("n", "#",  "<Plug>(asterisk-z#)")
map("n", "g#", "<Plug>(asterisk-gz#)")

map("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<CR>")
map("n", "<leader>fb", ":lua require('telescope.builtin').buffers()<CR>")
map("n", "<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>")
map("n", "<leader>fc", ":lua require('telescope.builtin').git_commits()<CR>")
map("n", "<leader>ft", ":lua require('telescope.builtin').builtin()<CR>")
