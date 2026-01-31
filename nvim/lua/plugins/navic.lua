return {
  'SmiteshP/nvim-navic',
  dependencies = 'neovim/nvim-lspconfig',
  opts = {
    highlight = true,
    separator = ' > ',
    depth_limit = 0,
    depth_limit_indicator = '..',
    safe_output = true,
    click = true,
  },
  config = function(_, opts)
    require('nvim-navic').setup(opts)
  end,
}
