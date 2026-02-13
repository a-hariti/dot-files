return {
  'williamboman/mason.nvim',
  event = { 'BufWinEnter' },
  config = function()
    require('mason').setup()
  end,
}
