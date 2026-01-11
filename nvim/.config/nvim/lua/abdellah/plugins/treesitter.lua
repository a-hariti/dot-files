--- @param bufnr number: buffer number
--- @return boolean: whether the file is too large to parse (10000 lines)
local function is_file_too_large(bufnr)
  local size = vim.api.nvim_buf_line_count(bufnr)
  return size > 10000
end

--- @param bufnr number: buffer number
--- @return boolean: whether the file is likely minified
local function is_minified_file(bufnr)
  -- is likely minified if one of the first 5 lines is longer than 1000 characters
  local first_5_lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
  for _, line in ipairs(first_5_lines) do
    if #line > 1000 then
      return true
    end
  end
  return false
end

local function config()
  require('nvim-treesitter.configs').setup({
    -- make linter happy
    modules = {},
    ensure_installed = {
      'javascript',
      'typescript',
      'tsx',
      'html',
      'css',
      'jsdoc',
      'comment',
      'rust',
      'yaml',
      'json',
      'lua',
      'vimdoc',
    },
    auto_install = true,
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = { 'latex' },
    highlight = {
      -- `false` will disable the whole extension
      enable = true,
      -- list of language that will be disabled
      disable = function(lang, bufnr)
        return is_file_too_large(bufnr) or is_minified_file(bufnr)
      end,
    },
    indent = {
      enable = false,
    },
    rainbow = {
      enable = false,
      -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      extended_mode = false,
    },
    refactor = {
      navigation = {
        enable = false,
        keymaps = {
          goto_next_usage = ']u',
          goto_previous_usage = '[u',
        },
      },
    },
    ['treesitter-context'] = {
      enable = false,
    },
    autotag = {
      enable = false,
      filetypes = {
        'html',
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'svelte',
        'vue',
        'tsx',
        'jsx',
        'rescript',
        'xml',
        'php',
        'markdown',
        'astro',
        'glimmer',
        'handlebars',
        'hbs',
        'heex',
      },
    },
    textobjects = {
      enable = false,
      select = {
        enable = false,

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
          ['aC'] = { query = '@function.call', query_group = 'textobjects', desc = 'Select a function call' },
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
        include_surrounding_whitespace = false,
      },
      move = {
        -- TODO: might come back to this later
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']f'] = '@function.outer',
          [']]'] = { query = '@class.outer', desc = 'Next class start' },
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- set to `false` to disable one of the mappings
        init_selection = '<leader>v',
        scope_incremental = '<C-n>',
        node_incremental = '<tab>',
        node_decremental = '<s-tab>',
      },
    },
  })
end

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- 'p00f/nvim-ts-rainbow',
    'nvim-treesitter/nvim-treesitter-refactor',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/playground',
    -- 'nvim-treesitter/nvim-treesitter-context',
  },
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })()
  end,
  config = config,
  event = { 'BufRead', 'BufNewFile' },
}
