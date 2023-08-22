local function config()
  local nulls = require('null-ls')

  nulls.setup({
    -- Don't clutter my cwd
    temp_dir = '/tmp/',

    sources = {
      -- PHP
      nulls.builtins.formatting.pint,
      nulls.builtins.diagnostics.phpstan,

      -- Python
      nulls.builtins.diagnostics.ruff,
      nulls.builtins.formatting.ruff,

      -- Lua
      nulls.builtins.formatting.stylua,

      -- Shell
      nulls.builtins.formatting.beautysh,

      -- Prettier
      nulls.builtins.formatting.prettier.with({
        extra_args = { '--config-precedence', 'prefer-file', '--single-quote', '--print-width', 100, '--tab-width', 2 },
        filetypes = {
          'html',
          'json',
          'svelte',
          'css',
          'scss',
          'svg',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
      }),
      nulls.builtins.formatting.deno_fmt.with({
        filetypes = { 'markdown' },
        extra_args = { '--', '--line-width', 120 },
      }),
    },
  })
end

return {
  'jose-elias-alvarez/null-ls.nvim',
  event = 'BufReadPost',
  config = config,
}
