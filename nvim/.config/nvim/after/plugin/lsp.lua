local lspconfig = require('lspconfig')

local lsp_mapings = function(bufnr)
  local telescope = require('telescope.builtin')
  local opts = { buffer = bufnr, remap = false }
  local ERROR = vim.diagnostic.severity.ERROR
  local map = vim.keymap.set
  map('n', '<C-]>', vim.lsp.buf.definition, opts)
  map('n', '<leader>gi', vim.lsp.buf.implementation, opts)
  map('n', '<leader>gr', telescope.lsp_references, opts)
  map('n', '<leader>gn', vim.lsp.buf.rename, opts)
  map('n', '<leader>k', vim.lsp.buf.hover, opts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  map('n', ']d', vim.diagnostic.goto_next, opts)
  map('n', '[d', vim.diagnostic.goto_prev, opts)
  -- Error specific navigation
  map('n', ']e', function()
    vim.diagnostic.goto_next({ severity = ERROR })
  end, opts)
  map('n', '[e', function()
    vim.diagnostic.goto_prev({ severity = ERROR })
  end, opts)
  map('n', '<leader>s', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(ev)
    lsp_mapings(ev.buf)
  end,
})

-- https://github.com/elixir-tools/elixir-tools.nvim
require('elixir').setup()

require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = { 'tsserver', 'lua_ls' } })

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
cmp_capabilities.offsetEncoding = 'utf-8'

require('mason-lspconfig').setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = cmp_capabilities,
      -- on_attach = lsp_mappings,
    })
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  ['tsserver'] = function()
    lspconfig.tsserver.setup({
      capabilities = cmp_capabilities,
      on_attach = function(client)
        client.server_capabilities.document_formatting = false
      end,
    })
  end,
  ['lua_ls'] = function()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    local lua_opts = {
      capabilities = cmp_capabilities,
      -- on_attach = lsp_mappings,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT', path = runtime_path },
          diagnostics = { globals = { 'vim' } },
          workspace = { -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
          },
        },
      },
    }
    lspconfig.lua_ls.setup(lua_opts)
  end,

  ['tailwindcss'] = function()
    lspconfig.tailwindcss.setup({
      init_options = { userLanguages = { elixir = 'html-eex', eelixir = 'html-eex', heex = 'html-eex' } },
      settings = { tailwindCSS = { experimental = { classRegex = { 'class[:]\\s*"([^"]*)"' } } } },

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
    })
  end,
})
