return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    local conform = require('conform')
    conform.setup({
      -- format after save let's you save immediately then do the formatting
      format_after_save = {
        -- These options will be passed to conform.format()
        -- timeout_ms = 500,
        async = true,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        html = { 'prettierd' },
        svg = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'fixjson', 'prettierd' },
        svelte = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        graphql = { 'prettierd' },
        sh = { 'shfmt' },
        go = { 'gofmt', 'goimports' },
      },
    })
    vim.keymap.set({ 'n', 'v' }, '<leader>s', function()
      conform.format({ lsp_fallback = true, async = true, timeout_ms = 500 })
    end)
  end,
}
