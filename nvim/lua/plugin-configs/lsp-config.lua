local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  print('lspconfig not found')
  return
end

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'tsserver', 'sumneko_lua' },
})

local mappings = require('mappings')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local lua_opts = {
  capabilities = cmp_capabilities,
  on_attach = mappings.lsp_mappings,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
}
lspconfig.sumneko_lua.setup(lua_opts)

lspconfig.tsserver.setup({
  capabilities = cmp_capabilities,
  on_attach = mappings.lsp_mappings,
})

lspconfig.html.setup({
  capabilities = cmp_capabilities,
  on_attach = mappings.lsp_mappings,
})

lspconfig.tailwindcss.setup({
  capabilities = cmp_capabilities,
  -- on_attach = mappings.lsp_mappings,
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'classList' },
      experimental = {
        -- Elm syntax
        classRegex = {
          'class "([^"]*)',
        },
      },
    },
  },
})
lspconfig.csharp_ls.setup({
  capabilities = cmp_capabilities,
  on_attach = mappings.lsp_mappings,
})

-- if server.name == 'denols' then
--   opts.root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc')
-- end
