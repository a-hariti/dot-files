return {
  'folke/which-key.nvim',
  event = 'UIEnter',
  config = function()
    require('which-key').setup({})
  end,
}
