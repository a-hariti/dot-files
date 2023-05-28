vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */lua/plugins.lua exe 'luafile ' . expand('<afile>')  | PackerCompile
  augroup end
]])

vim.cmd([[
  augroup vimrc
    au!

    "relative numbers for normal mode only
    au InsertEnter * set norelativenumber
    au InsertLeave * set relativenumber

    au FileType go setlocal noexpandtab
    au FileType elm setlocal foldmethod=syntax

    " auto reload vimrc on save
    au! BufWritePost init.vim so % | redraw

    " highlight yanked range
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 50})

  augroup END
]])
