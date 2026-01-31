return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local todo_comments = require('todo-comments')
    local map = vim.keymap.set
    map('n', ']t', function()
      todo_comments.jump_next()
    end, { desc = 'Next todo comment' })

    map('n', '[t', function()
      todo_comments.jump_prev()
    end, { desc = 'Previous todo comment' })

    todo_comments.setup({})
  end,
  opts = {},
}
