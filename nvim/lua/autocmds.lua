local vimrc_group = vim.api.nvim_create_augroup('vimrc', { clear = true })

-- disable expandtab for go
vim.api.nvim_create_autocmd(
  'FileType',
  { group = vimrc_group, pattern = 'go', callback = function() vim.opt_local.expandtab = false end }
)

vim.api.nvim_create_autocmd(
  'FileType',
  { group = vimrc_group, pattern = 'elm', callback = function() vim.opt_local.foldmethod = 'syntax' end }
)

-- highlight yanked text
vim.api.nvim_create_autocmd(
  'TextYankPost',
  { group = vimrc_group, callback = function() vim.hl.on_yank({ timeout = 50 }) end }
)

-- relative line numbers in insert mode only
local insert_relative_nr_group = vim.api.nvim_create_augroup('InsertRelativeNumber', { clear = true })
local function set_relative_number(relativenumber)
  return function() vim.wo.relativenumber = relativenumber end
end
vim.api.nvim_create_autocmd('InsertEnter', { group = insert_relative_nr_group, callback = set_relative_number(false) })
vim.api.nvim_create_autocmd('InsertLeave', { group = insert_relative_nr_group, callback = set_relative_number(true) })

-- highlight mdx files as markdown
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.mdx',
  callback = function(args) vim.bo[args.buf].filetype = 'markdown' end,
})

local function looks_like_jsonc(bufnr)
  local max_lines = math.min(vim.api.nvim_buf_line_count(bufnr), 200)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_lines, false)
  local text = table.concat(lines, '\n')
  local in_string = false
  local escaped = false
  local i = 1
  local n = #text

  while i <= n do
    local c = text:sub(i, i)
    if in_string then
      if escaped then
        escaped = false
      elseif c == '\\' then
        escaped = true
      elseif c == '"' then
        in_string = false
      end
      i = i + 1
    else
      if c == '"' then
        in_string = true
        i = i + 1
      elseif c == '/' then
        local next_c = text:sub(i + 1, i + 1)
        if next_c == '/' or next_c == '*' then return true end
        i = i + 1
      elseif c == ',' then
        local j = i + 1
        while j <= n do
          local ws = text:sub(j, j)
          if ws == ' ' or ws == '\t' or ws == '\n' or ws == '\r' then
            j = j + 1
          else
            break
          end
        end
        local next_c = text:sub(j, j)
        if next_c == '}' or next_c == ']' then return true end
        i = i + 1
      else
        i = i + 1
      end
    end
  end

  return false
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.json',
  callback = function(args)
    if looks_like_jsonc(args.buf) then vim.bo[args.buf].filetype = 'jsonc' end
  end,
})
