local ok, autopairs = pcall(require, 'nvim-autopairs')

if not ok then
  return print('autopairs not found')
end

autopairs.setup({})
