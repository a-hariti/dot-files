require('nvim-tree').setup({
  view = { relativenumber = true, adaptive_size = true },
  filters = { custom = { '.git' } },
})
