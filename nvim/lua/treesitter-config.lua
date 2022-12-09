local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('nvim-treesitter.configs not found')
  return
end

configs.setup({
  ensure_installed = {
    'javascript',
    'typescript',
    'tsx',
    'html',
    'css',
    'jsdoc',
    'comment',
    'go',
    'rust',
    'yaml',
    'json',
    'jsonc',
    'lua',
    'c',
  },
  auto_install = true, -- Install languages synchronously (only applied to `ensure_installed`)
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
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
      },

      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    move = {
      -- TODO: might come back to this later
      enable = false,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = { query = '@class.outer', desc = 'Next class start' },
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
})
