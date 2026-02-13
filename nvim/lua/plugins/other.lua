return {
  'rgroli/other.nvim',
  event = 'BufReadPost',
  config = function()
    vim.keymap.set('n', '<leader>o', ':Other<CR>')
    require('other-nvim').setup({
      mappings = {
        -- C source <-> header
        { pattern = '(.*)%.c$', target = '%1.h', context = 'source' },
        { pattern = '(.*)%.h$', target = '%1.c', context = 'header' },

        -- navigate from page|layout.svelte to page|layout.server.ts
        {
          pattern = '/src/routes/(.*)/(.*).svelte$',
          target = '/src/routes/%1/%2.server.ts',
          context = 'view',
        },
        -- navigate from page|layout.server.ts to page|layout.svelte
        {
          pattern = '/src/routes/(.*)/(.*).server.ts$',
          target = '/src/routes/%1/%2.svelte',
          context = 'server',
        },
      },
    })
  end,
}
