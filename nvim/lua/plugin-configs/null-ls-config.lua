local ok, nulls = pcall(require, 'null-ls')
if not ok then
  print('null-ls moudle not found')
  return
end
local builtins = nulls.builtins
nulls.setup({
  sources = {
    builtins.formatting.ruff,
    builtins.formatting.black,
    builtins.diagnostics.ruff,
    builtins.formatting.latexindent,
    builtins.formatting.stylua,
    -- builtins.diagnostics.eslint,
    -- builtins.formatting.eslint,
    builtins.formatting.beautysh,
    builtins.formatting.prettier.with({
      extra_args = {
        '--config-precedence',
        'prefer-file',
        '--single-quote',
        '--print-width',
        100,
        '--tab-width',
        2,
      },
      filetypes = {
        'html',
        'json',
        'svelte',
        -- 'markdown',
        'css',
        'scss',
        'svg',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
      },
    }),
    builtins.formatting.deno_fmt.with({
      filetypes = { 'markdown' }, -- only runs `deno fmt` for markdown
      extra_args = { '--', '--line-width', 120 },
    }),
  },
})
