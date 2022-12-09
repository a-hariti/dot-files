local success, indent_blankline = pcall(require, 'indent_blankline')
if success then
  indent_blankline.setup({
    char = '┊',
    show_current_context = true,
    -- show_current_context_start = true,
  })
else
  print('indent_blankline module not found')
end

local success, trim = pcall(require, 'trim')
if success then
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

local success, lualine = pcall(require, 'lualine')
if success then
  lualine.setup({})
else
  print('lualine module not found')
end

local success, lualine = pcall(require, 'which-key')
if success then
  lualine.setup({})
else
  print('which-key module not found')
end

local success, nvim_tree = pcall(require, 'nvim-tree')
if success then
  nvim_tree.setup({
    view = { relativenumber = true },
    filters = { custom = { '.git' } },
  })
else
  print('nvim_tree module not found')
end
