vim.cmd([[
  augroup vimrc
    au!

    au FileType go setlocal noexpandtab
    au FileType elm setlocal foldmethod=syntax

    " highlight yanked range
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 50})

  augroup END
]])

vim.cmd([[
  augroup InsertRelativeNumber
    au!
    "relative numbers for normal mode only
    au InsertEnter * set norelativenumber
    au InsertLeave * set relativenumber
]])

local function looks_like_jsonc(bufnr)
  local max_lines = math.min(vim.api.nvim_buf_line_count(bufnr), 200)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_lines, false)
  local text = table.concat(lines, '\n')
  return text:find('//', 1, true) ~= nil or text:find('/%*') ~= nil or text:find(',%s*[}%]]') ~= nil
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.json',
  callback = function(args)
    if looks_like_jsonc(args.buf) then vim.bo[args.buf].filetype = 'jsonc' end
  end,
})
