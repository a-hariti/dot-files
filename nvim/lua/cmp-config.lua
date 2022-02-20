local cmp = require "cmp"

cmp.setup(
  {
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({select = true}),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
      ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"})
    },
    sources = cmp.config.sources(
      {
        {name = "nvim_lsp"},
        {name = "luasnip"},
        {name = "buffer"}
      }
    ),
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    }
  }
)
