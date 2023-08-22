return {
  'kyazdani42/nvim-tree.lua',
  event = 'BufWinEnter',
  config = function()
    require('nvim-tree').setup({
      hijack_netrw = true,
      view = { relativenumber = true, adaptive_size = true },
      filters = { custom = { '.git' } },
    })
  end,
}
