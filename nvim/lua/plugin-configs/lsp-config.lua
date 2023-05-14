local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  print('lspconfig not found')
  return
end

local rust_tools = require('rust-tools')

local mappings = require('mappings')

rust_tools.setup({
  server = {
    on_attach = function(_, _)
      mappings.lsp_mappings()
    end,
  },
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'tsserver', 'lua_ls' },
})

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
cmp_capabilities.offsetEncoding = 'utf-8'

require('mason-lspconfig').setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = cmp_capabilities,
      on_attach = mappings.lsp_mappings,
    })
  end,
  ['tsserver'] = function()
    lspconfig.tsserver.setup({
      capabilities = cmp_capabilities,
      on_attach = function(client)
        client.server_capabilities.document_formatting = false
        mappings.lsp_mappings()
      end,
    })
  end,
  -- ['svelte'] = function()
  --   lspconfig.tsserver.setup({
  --     capabilities = cmp_capabilities,
  --     on_attach = function(client)
  --       client.server_capabilities.document_formatting = false
  --       mappings.lsp_mappings()
  --     end,
  --   })
  -- end,
  -- Next, you can provide a dedicated handler for specific servers.
  ['tailwindcss'] = function()
    lspconfig.tailwindcss.setup({
      capabilities = cmp_capabilities,
      on_attach = mappings.lsp_mappings,
      -- filetypes copied and adjusted from tailwindcss-intellisense
      filetypes = {
        -- html
        'aspnetcorerazor',
        'astro',
        'astro-markdown',
        'blade',
        'django-html',
        'htmldjango',
        'edge',
        'eelixir', -- vim ft
        'elixir',
        'ejs',
        'erb',
        'eruby', -- vim ft
        'gohtml',
        'haml',
        'handlebars',
        'hbs',
        'html',
        -- 'HTML (Eex)',
        -- 'HTML (EEx)',
        'html-eex',
        'heex',
        'jade',
        'leaf',
        'liquid',
        'markdown',
        'mdx',
        'mustache',
        'njk',
        'nunjucks',
        'php',
        'razor',
        'slim',
        'twig',
        -- css
        'css',
        'less',
        'postcss',
        'sass',
        'scss',
        'stylus',
        'sugarss',
        -- js
        'javascript',
        'javascriptreact',
        'reason',
        'rescript',
        'typescript',
        'typescriptreact',
        -- mixed
        'vue',
        'svelte',
        'elm',
      },
      settings = {
        tailwindCSS = {
          classAttributes = { 'class', 'className', 'classList' },
          experimental = {
            -- Elm syntax
            classRegex = {
              '\\bclass[\\s(<|]+"([^"]*)"',
              '\\bclass[\\s(]+"[^"]*"[\\s+]+"([^"]*)"',
              '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
              '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
              '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
              '\\bclassList[\\s\\[\\(]+"([^"]*)"',
              '\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
              '\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
            },
          },
        },
      },
    })
  end,
  ['lua_ls'] = function()
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
    lspconfig.lua_ls.setup(lua_opts)
  end,
})
