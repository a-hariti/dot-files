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

local ok, lualine = pcall(require, 'lualine')
if ok then
  lualine.setup({})
else
  print('lualine module not found')
end

local ok, lualine = pcall(require, 'which-key')
if ok then
  lualine.setup({})
else
  print('which-key module not found')
end

local ok, nvim_tree = pcall(require, 'nvim-tree')
if ok then
  nvim_tree.setup({
    view = { relativenumber = true, ive_size = true },
    filters = { custom = { '.git' } },
  })
else
  print('nvim_tree module not found')
end
