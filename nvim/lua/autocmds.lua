vim.cmd([[
  augroup vimrc
    au!

    au FileType go setlocal noexpandtab
    au FileType elm setlocal foldmethod=syntax

    " highlight yanked range
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 50})

  augroup END
]])

vim.cmd([[
  augroup InsertRelativeNumber
    au!
    "relative numbers for normal mode only
    au InsertEnter * set norelativenumber
    au InsertLeave * set relativenumber
]])
