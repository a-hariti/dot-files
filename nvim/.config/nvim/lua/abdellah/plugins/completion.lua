local function config()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  -- load vsocdoe like snippets (makes friendly-snippets work)
  require('luasnip/loaders/from_vscode').lazy_load()

  cmp.setup({
    mapping = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ['<C-e>'] = cmp.mapping.close(),

      -- Ctrl+c to trigger completion menu
      ['<C-c>'] = cmp.mapping.complete(),

      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-s>'] = cmp.mapping.scroll_docs(4),

      ['<C-f>'] = cmp.mapping(function(fallback)
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-b>'] = cmp.mapping(function(fallback)
        if luasnip.expand_or_locally_jumpable(-1) then
          luasnip.expand_or_jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { 'i', 'c' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 'c' }),
    },
    formatting = {
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
      format = require('lspkind').cmp_format({
        mode = 'symbol', -- show only symbol annotations
        maxwidth = 50,
        ellipsis_char = '...',
      }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'cmd-line' },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp_signature_help' },
    }),
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' },
      }, { { name = 'cmdline' } }),
    }),
    cmp.setup.cmdline({ '/', '?' }, { sources = { { name = 'buffer' } } }),
  })
end
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'onsails/lspkind.nvim',
  },
  config = config,
  event = 'InsertEnter',
}
