local telescope = require('telescope')
local action_set = require('telescope.actions.set')

telescope.setup({
  pickers = {
    find_files = {
      attach_mappings = function()
        action_set.select:enhance({
          post = function()
            vim.cmd(':normal! zx')
          end,
        })
        return true
      end,
    },
  },
})
