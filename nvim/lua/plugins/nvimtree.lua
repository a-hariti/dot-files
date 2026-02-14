return {
  'nvim-tree/nvim-tree.lua',
  event = 'BufWinEnter',
  config = function()
    require('nvim-tree').setup({
      hijack_netrw = true,
      view = { relativenumber = true, adaptive_size = true },
      filters = { custom = { '.git' } },
    })
    local keymap = vim.keymap
    keymap.set(
      { 'n', 'v' },
      '<leader>e',
      '<cmd>NvimTreeFindFile<CR>',
      { desc = 'Toggle file explorer and focus current file' }
    )
		-- Meta is sent from the terminal to make it this valid insde Tmux as well
		-- D comes from unconfigured terminals
    for _, k in ipairs({ '<D-B>', '<M-b>' }) do
      keymap.set({ 'n', 'v' }, k, '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
    end
    keymap.set('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>')
  end,
}
