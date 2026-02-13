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
    keymap.set({ 'n', 'v' }, '<D-b>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
    keymap.set('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>')
  end,
}
