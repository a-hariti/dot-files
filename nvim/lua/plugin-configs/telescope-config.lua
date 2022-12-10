local ok, telescope = pcall(require, 'telescope')
--- safe require alredy as if telescope require suceeds, then the actions will be there
local _, action_set = pcall(require, 'telescope.actions.set')

if not ok then
    print('telescope module not found')
    return
end

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
