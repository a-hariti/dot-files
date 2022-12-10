local ok, trim = pcall(require, 'trim')
if ok then
  trim.setup({
    patterns = {
      [[%s/\s\+$//e]], -- remove unwanted spaces
      [[%s/\($\n\s*\)\+\%$//]], -- trim last line
      [[%s/\%^\n\+//]], -- trim first line
    },
  })
else
  print('trim module not found')
end
