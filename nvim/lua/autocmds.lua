vim.cmd([[
  augroup vimrc
    au!

    au FileType go setlocal noexpandtab
    au FileType elm setlocal foldmethod=syntax

    " highlight yanked range
    autocmd TextYankPost * silent! lua require'vim.hl'.on_yank({timeout = 50})

  augroup END
]])

vim.cmd([[
  augroup InsertRelativeNumber
    au!
    "relative numbers for normal mode only
    au InsertEnter * set norelativenumber
    au InsertLeave * set relativenumber
  augroup END
]])

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
