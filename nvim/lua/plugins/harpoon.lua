return {
  'ThePrimeagen/harpoon',
  event = 'BufRead',
  config = function()
    require('harpoon').setup({})

    -- Harpoon
    local harpoon_ui = require('harpoon.ui')
    local map = vim.keymap.set

    map('n', '<leader>0', function() harpoon_ui.toggle_quick_menu() end)
    map('n', '<leader>m', function() require('harpoon.mark').add_file() end)
    map('n', '<leader>,', function() harpoon_ui.nav_prev() end)
    map('n', '<leader>.', function() harpoon_ui.nav_next() end)
    map('n', '<leader>1', function() harpoon_ui.nav_file(1) end)
    map('n', '<leader>2', function() harpoon_ui.nav_file(2) end)
    map('n', '<leader>3', function() harpoon_ui.nav_file(3) end)
    map('n', '<leader>4', function() harpoon_ui.nav_file(4) end)
  end,
}
