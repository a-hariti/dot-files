local lsp_installer = require('nvim-lsp-installer')
local lsp_signature = require('lsp_signature')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local mappings = require('mappings')

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = function(client)
      -- defer formatting to null-ls
      if client.name == 'sumneko_lua' or client.name == 'tsserver' then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
      end
      lsp_signature.on_attach()
      mappings.lsp_mappings()
    end,
    capabilities = capabilities,
  }

  if server.name == 'tailwindcss' then
    opts.settings = {
      tailwindCSS = {
        classAttributes = { 'class', 'className', 'classList' },
      },
    }
  end

  if server.name == 'sumneko_lua' then
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    opts.settings = {
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
    }
  end

  -- This setup() function will take the provided server configuration and decorate it with the necessary properties
  -- before passing it onwards to lspconfig.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)
