return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local null_ls = require('null-ls')
    local formatting = null_ls.builtins.formatting

    local function is_none_ls(client) return client.name == 'null-ls' or client.name == 'none-ls' end

    null_ls.setup({
      sources = {
        formatting.prettierd,
        formatting.shfmt,
        formatting.stylua,
      },
    })

    vim.keymap.set(
      { 'n', 'v' },
      '<leader>s',
      function() vim.lsp.buf.format({ timeout_ms = 500, filter = is_none_ls }) end,
      { desc = 'Format buffer/selection with none-ls' }
    )
  end,
}
