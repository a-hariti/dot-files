require('nvim-tree').setup({
  view = { relativenumber = true, adaptive_size = false },
  filters = { custom = { '.git' } },
})
