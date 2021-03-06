local nulls = require('null-ls')
local builtins = nulls.builtins
nulls.setup({
  sources = {
    builtins.formatting.stylua,
    builtins.diagnostics.eslint,
    builtins.formatting.eslint,
    builtins.formatting.prettier.with({
      extra_args = {
        '--config-precedence',
        'file-override',
        '--single-quote',
        '--print-width',
        120,
        '--tab-width',
        4,
      },
      filetypes = {
        'html',
        'json',
        'svelte',
        'markdown',
        'css',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
      },
    }),
  },
})
