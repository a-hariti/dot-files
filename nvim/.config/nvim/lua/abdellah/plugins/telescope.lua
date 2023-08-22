return {
  'nvim-telescope/telescope.nvim',
  event = 'UIEnter',
  config = function()
    local telescope = require('telescope')
    local action_set = require('telescope.actions.set')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        mappings = { n = { ['<C-q>'] = actions.smart_send_to_qflist } },
      },
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
  end,
}
