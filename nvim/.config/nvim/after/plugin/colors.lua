local ok = pcall(vim.cmd.colorscheme, 'vim-material')
if ok then
  -- change the default error virtual text color
  vim.cmd([[ hi link DiagnosticVirtualTextError DiagnosticError ]])
else
  print('colorscheme not found')
end
