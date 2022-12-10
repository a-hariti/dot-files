local ok, lualine = pcall(require, 'lualine')
if ok then
  lualine.setup({})
else
  print('lualine module not found')
end
