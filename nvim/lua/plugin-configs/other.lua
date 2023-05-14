--  +layout.server.ts
--  +layout.svelte
--  +page.server.ts
--  +page.svelte

require('other-nvim').setup({
  mappings = {
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
