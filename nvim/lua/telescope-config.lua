local action_set = require('telescope.actions.set')

require('telescope').setup {
  pickers = {
    find_files = {
      attach_mappings = function(prompt_bufnr)
        action_set.select:enhance({
          post = function()
            vim.cmd(":normal! zx")
          end
        })
        return true
      end
    },
  }
}
