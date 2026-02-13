local function config()
  local lsp_mapings = function(bufnr)
    local telescope = require('telescope.builtin')
    local opts = { buffer = bufnr, remap = false }
    local ERROR = vim.diagnostic.severity.ERROR
    local map = vim.keymap.set
    map('n', '<C-]>', vim.lsp.buf.definition, opts)
    map('n', '<leader>gi', vim.lsp.buf.implementation, opts)
    map('n', 'gr', telescope.lsp_references, opts)
    map('n', '<leader>n', vim.lsp.buf.rename, opts)
    map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    map('n', ']e', function() vim.diagnostic.jump({ count = 1, severity = ERROR }) end, opts)
    map('n', '[e', function() vim.diagnostic.jump({ count = -1, severity = ERROR }) end, opts)
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, ev.buf)
      end
      lsp_mapings(ev.buf)
    end,
  })

  local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  vim.lsp.config('*', { capabilities = cmp_capabilities })

  vim.lsp.config(
    'texlab',
    { settings = { texlab = { latexFormatter = 'latexindent', latexindent = { modifyLineBreaks = true } } } }
  )

  vim.lsp.config('ts_ls', {
    on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
  })

  vim.lsp.config(
    'lua_ls',
    { settings = { Lua = { diagnostics = { globals = { 'vim' } }, telemetry = { enable = false } } } }
  )

  local mason_lspconfig = require('mason-lspconfig')
  mason_lspconfig.setup({
    ensure_installed = { 'ts_ls', 'lua_ls', 'ty' },
    automatic_enable = false,
  })

  for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
    vim.lsp.enable(server_name)
  end

  vim.lsp.enable('tailwindcss')

  -- sourcekit-lsp is typically provided by the local Swift/Xcode toolchain, not mason.
  local sourcekit_cmd = vim.fn.executable('xcrun') == 1 and { 'xcrun', 'sourcekit-lsp' } or { 'sourcekit-lsp' }
  vim.lsp.config('sourcekit', { cmd = sourcekit_cmd, filetypes = { 'swift' } })

  vim.lsp.enable('sourcekit')
  vim.lsp.enable('clangd')
  vim.lsp.enable('ruff')
  vim.lsp.enable('ty')
end
return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  config = config,
}
