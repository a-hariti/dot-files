return {
  'folke/which-key.nvim',
  event = 'UIEnter',
  config = function()
    require('which-key').setup({
      delay = 1500,
    })
  end,
}
