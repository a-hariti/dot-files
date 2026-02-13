return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local null_ls = require('null-ls')
    local formatting = null_ls.builtins.formatting
    local function is_none_ls(client) return client.name == 'null-ls' or client.name == 'none-ls' end

    local function should_attach(bufnr)
      if vim.api.nvim_buf_line_count(bufnr) > 10000 then return false end
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name:find('/node_modules/', 1, true) or name:find('/dist/', 1, true) then return false end
      if name:match('%.min%.[cm]?js$') then return false end
      if name:match('[/\\]package%-lock%.json$') then return false end
      if name:match('[/\\]pnpm%-lock%.yaml$') then return false end
      if name:match('[/\\]yarn%.lock$') then return false end
      return true
    end

    local prettierd_filetypes = vim.tbl_filter(
      function(ft) return ft ~= 'json' and ft ~= 'jsonc' end,
      formatting.prettierd.filetypes or {}
    )

    null_ls.setup({
      should_attach = should_attach,
      sources = {
        formatting.prettierd.with({ filetypes = prettierd_filetypes }),
        formatting.prettier.with({ filetypes = { 'json', 'jsonc' } }),
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
