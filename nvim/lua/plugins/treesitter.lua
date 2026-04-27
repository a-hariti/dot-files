--- @param bufnr number: buffer number
--- @return boolean: whether the file is too large to parse (10000 lines)
local function is_file_too_large(bufnr)
  local size = vim.api.nvim_buf_line_count(bufnr)
  return size > 10000
end

--- @param bufnr number: buffer number
--- @return boolean: whether the file is likely minified
local function is_minified_file(bufnr)
  -- is likely minified if one of the first 5 lines is longer than 1000 characters
  local first_5_lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
  for _, line in ipairs(first_5_lines) do
    if #line > 1000 then return true end
  end
  return false
end

local parsers = {
  'javascript',
  'typescript',
  'tsx',
  'html',
  'css',
  'jsdoc',
  'comment',
  'rust',
  'yaml',
  'json',
  'lua',
  'vim',
  'vimdoc',
  'markdown',
  'markdown_inline',
}

local function configure_treesitter()
  require('nvim-treesitter').setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
    callback = function(args)
      if is_file_too_large(args.buf) or is_minified_file(args.buf) then return end

      local ok = pcall(vim.treesitter.start, args.buf)
      if ok then vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end,
  })
end

local function configure_textobjects()
  require('nvim-treesitter-textobjects').setup({
    select = {
      lookahead = true,
      include_surrounding_whitespace = false,
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require('nvim-treesitter-textobjects.select')
  vim.keymap.set({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
  vim.keymap.set({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)
  vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
  vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
  vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@conditional.outer', 'textobjects') end)
  vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@conditional.inner', 'textobjects') end)
  vim.keymap.set({ 'x', 'o' }, 'aC', function() select.select_textobject('@function.call', 'textobjects') end)

  local move = require('nvim-treesitter-textobjects.move')
  vim.keymap.set(
    { 'n', 'x', 'o' },
    ']f',
    function() move.goto_next_start('@function.outer', 'textobjects') end,
    { desc = 'Next function start' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    ']]',
    function() move.goto_next_start('@class.outer', 'textobjects') end,
    { desc = 'Next class start' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    ']F',
    function() move.goto_next_end('@function.outer', 'textobjects') end,
    { desc = 'Next function end' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '][',
    function() move.goto_next_end('@class.outer', 'textobjects') end,
    { desc = 'Next class end' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '[f',
    function() move.goto_previous_start('@function.outer', 'textobjects') end,
    { desc = 'Previous function start' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '[[',
    function() move.goto_previous_start('@class.outer', 'textobjects') end,
    { desc = 'Previous class start' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '[F',
    function() move.goto_previous_end('@function.outer', 'textobjects') end,
    { desc = 'Previous function end' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '[]',
    function() move.goto_previous_end('@class.outer', 'textobjects') end,
    { desc = 'Previous class end' }
  )
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = function()
      local update = require('nvim-treesitter').update(parsers, { summary = true, max_jobs = 1 })
      if update and update.wait then update:wait(300000) end
    end,
    config = configure_treesitter,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = configure_textobjects,
  },
}
