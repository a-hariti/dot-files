return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  event = { 'BufWinEnter' },
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    require('mason-tool-installer').setup({
      ensure_installed = { 'prettierd', 'ruff', 'shfmt', 'shellcheck', 'stylua' },
    })
  end,
}
