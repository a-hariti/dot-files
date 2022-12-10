local ok, which_key = pcall(require, 'which-key')
if ok then
  which_key.setup({})
else
  print('which-key module not found')
end
