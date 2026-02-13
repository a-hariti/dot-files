---@class CenteredFloatOpts
---@field content_width? integer (default 100)
---@field pad? integer inner horizontal pad per side (default 4)
---@field bottom_gap? integer rows left free at bottom (default 1)
---@field signcolumn? string (default "yes:2")
---@field conceal_trailing_backslash? boolean (default true)

---Open current file buffer in a centered, full-height floating window with fixed content width.
---Background becomes an empty scratch buffer.
---@param opts? CenteredFloatOpts
local function open(opts)
  opts = opts or {}
  local content_w = opts.content_width or 100
  local pad = opts.pad or 4
  local bottom_gap = opts.bottom_gap or 1
  local signcolumn = opts.signcolumn or 'yes:2'
  local conceal_trailing_backslash = (opts.conceal_trailing_backslash ~= false)

  -- Capture currently open file buffer (argv buffer).
  local fileb = vim.api.nvim_get_current_buf()

  -- Create truly empty background scratch buffer.
  vim.cmd('enew')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.opt_local.fillchars:append({ eob = ' ' }) -- hide "~"

  -- q to quit
  vim.keymap.set('n', 'q', '<cmd>qall!<CR>', { noremap = true, silent = true })
  -- avoid relative line numbers on insert mode (usually set up by an autocmd in ./autocmds.lua)
  vim.api.nvim_create_augroup('InsertRelativeNumber', { clear = true })
  -- no status line

  -- Float geometry.
  local w = content_w + pad * 2
  local h = vim.o.lines - 2 - bottom_gap -- usable full height minus cmdline and chosen bottom gap
  local r = 0

  -- Enforce perfectly symmetric horizontal outer padding.
  local cols = vim.o.columns
  if (cols - w) % 2 ~= 0 then w = w - 1 end
  local c = (cols - w) / 2

  local win = vim.api.nvim_open_win(fileb, true, {
    relative = 'editor',
    row = r,
    col = c,
    width = w,
    height = h,
    style = 'minimal',
    border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }, -- visual side padding frame
  })

  -- Window-local behavior.
  vim.wo[win].signcolumn = signcolumn
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true -- no mid-word breaks
  vim.wo[win].breakindent = true
  vim.wo[win].showbreak = ''
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].foldcolumn = '0'
  vim.wo[win].statusline = ''
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = 'nc'

  -- Conceal trailing "\" at EOL.
  if conceal_trailing_backslash then
    vim.api.nvim_set_current_win(win)
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn.matchadd('Conceal', [[\\$]], 10, -1, { conceal = '' })
  end

  -- Transparent/empty float look.
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', ctermbg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none', ctermbg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', {
    bg = 'none',
    fg = 'none',
    ctermbg = 'none',
    ctermfg = 'none',
  })
  vim.api.nvim_set_option_value('winhighlight', 'Normal:NormalFloat,FloatBorder:FloatBorder', { win = win })
end

_G.CenteredFloatOpen = open
