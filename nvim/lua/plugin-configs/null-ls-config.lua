local ok, nulls = pcall(require, 'null-ls')
if not ok then
  print('null-ls moudle not found')
  return
end
local builtins = nulls.builtins
nulls.setup({
  sources = {
    builtins.formatting.stylua,
    -- builtins.diagnostics.eslint,
    -- builtins.formatting.eslint,
    builtins.formatting.prettier.with({
      extra_args = {
        '--config-precedence',
        'file-override',
        '--single-quote',
        '--print-width',
        120,
        '--tab-width',
        2,
      },
      filetypes = {
        'html',
        'json',
        'svelte',
        -- 'markdown',
        'css',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
      },
    }),
    builtins.formatting.deno_fmt.with({
      filetypes = { 'markdown' }, -- only runs `deno fmt` for markdown
    }),
  },
})
