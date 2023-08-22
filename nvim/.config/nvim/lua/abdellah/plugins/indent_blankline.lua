return {
  'lukas-reineke/indent-blankline.nvim',
  donfig = function()
    require('indent_blankline').setup({
      char = '┊',
      show_current_context = true,
    })
  end,
}
