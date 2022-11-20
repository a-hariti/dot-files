require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'javascript',
    'typescript',
    'tsx',
    'html',
    'css',
    'go',
    'rust',
    'yaml',
    'json',
    'jsonc',
    'lua',
    'c',
    'latex',
  },
  auto_install = true,
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- List of parsers to ignore installing
  ignore_install = {},
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = {},
  },
  context_commentstring = {
    enable = true,
  },
  rainbow = {
    enable = true,
    -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    extended_mode = false,
  },
  refactor = {
    navigation = {
      enable = true,
      keymaps = {
        goto_next_usage = ']u',
        goto_previous_usage = '[u',
      },
    },
  },
  matchup = {
    enable = true,
  },
  ['treesitter-context'] = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})
