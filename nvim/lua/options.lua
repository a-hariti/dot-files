vim.o.backup = false
vim.o.writebackup = true
vim.o.updatetime = 300
vim.o.signcolumn = "yes"
vim.o.expandtab = false
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.autoindent = true
vim.o.hidden = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.lazyredraw = true
vim.opt.shortmess:append("c")
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cursorline = true
vim.o.showmode = true
vim.o.list = true -- show white space
vim.o.listchars = "tab:  ,trail:·,precedes:«,extends:»"
vim.o.number = true
vim.o.relativenumber = true
vim.o.spelllang = "en,fr"

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99

vim.cmd("colorscheme tokyonight")
