-- High enough to keep things open initially
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- necessary autcmd to nudge nvim to build the fold tree
vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    -- using schedule ensures the buffer is fully attached
    -- and Treesitter is active before we poke the folds.
    vim.schedule(function()
      vim.opt.foldmethod = 'expr'
    end)
  end,
})

-- make the first zm useful (set foldlevel to be enough to close the level of the current line)
vim.keymap.set('n', 'zm', function()
  local cursor_line = vim.fn.line('.')
  local current_fold_level = vim.fn.foldlevel(cursor_line)

  -- If we aren't inside a fold (level 0), do nothing
  if current_fold_level == 0 then
    return
  end

  vim.wo.foldlevel = current_fold_level - 1
end, { desc = 'Fold more' })
