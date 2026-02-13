-- return {
--   'github/copilot.vim',
--   event = 'BufRead',
--   config = function()
--     vim.cmd([[ let g:copilot_no_tab_map = v:true ]])
--     local opts = { expr = true, script = true, replace_keycodes = false }
--     vim.keymap.set('i', '<C-j>', 'copilot#Next()', opts)
--     vim.keymap.set('i', '<C-k>', 'copilot#Previous()', opts)
--     vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', opts)
--     vim.keymap.set('i', '<C-x>', 'copilot#Dismiss()', opts)
--   end,
-- }

return {
  'Exafunction/codeium.vim',
  config = function()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set(
      'i',
      '<c-j>',
      function() return vim.fn['codeium#CycleCompletions'](1) end,
      { expr = true, silent = true }
    )
    vim.keymap.set(
      'i',
      '<c-k>',
      function() return vim.fn['codeium#CycleCompletions'](-1) end,
      { expr = true, silent = true }
    )
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end,
}
