local lsp_installer = require('nvim-lsp-installer')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local mappings = require('mappings')
local nvim_lsp = require('lspconfig')

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = function(client)
      -- defer formatting to null-ls
      for _, name in pairs({ 'sumneko_lua', 'tsserver', 'svelte', 'html' }) do
        if client.name == name then
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
        end
      end
      mappings.lsp_mappings()

      local active_clients = vim.lsp.get_active_clients()
      if client.name == 'denols' then
        for _, client_ in pairs(active_clients) do
          -- stop tsserver if denols is already active
          if client_.name == 'tsserver' then
            client_.stop()
          end
        end
      elseif client.name == 'tsserver' then
        for _, client_ in pairs(active_clients) do
          -- prevent tsserver from starting if denols is already active
          if client_.name == 'denols' then
            client.stop()
          end
        end
      end
    end,
    capabilities = capabilities,
  }

  if server.name == 'tailwindcss' then
    opts.settings = {
      tailwindCSS = {
        classAttributes = { 'class', 'className', 'classList' },
        experimental = {
          classRegex = {
            'class "([^"]*)',
          },
        },
      },
    }
    opts.filetypes = { 'html', 'sevelte', 'javascriptreact', 'typescriptreact', 'elm' }
  end

  if server.name == 'denols' then
    opts.root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc')
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
