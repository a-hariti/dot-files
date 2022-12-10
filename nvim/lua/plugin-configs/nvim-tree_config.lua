local ok, nvim_tree = pcall(require, 'nvim-tree')
if ok then
  nvim_tree.setup({
    view = { relativenumber = true, adaptive_size = true },
    filters = { custom = { '.git' } },
  })
else
  print('nvim_tree module not found')
end
