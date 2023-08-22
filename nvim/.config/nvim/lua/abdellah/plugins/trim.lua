return {
  'cappyzawa/trim.nvim',
  event = 'BufWritePre',
  config = function()
    require('trim').setup({
      patterns = {
        [[%s/\s\+$//e]], -- remove unwanted spaces
        [[%s/\($\n\s*\)\+\%$//]], -- trim last line
        [[%s/\%^\n\+//]], -- trim first line
      },
    })
  end,
}
