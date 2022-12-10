local ok, indent_blankline = pcall(require, 'indent_blankline')
if ok then
  indent_blankline.setup({
    char = '┊',
    show_current_context = true,
    -- show_current_context_start = true,
  })
else
  print('indent_blankline module not found')
end
