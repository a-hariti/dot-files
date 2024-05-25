return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
  },
  event = { 'BufWinEnter' },
  config = function()
    local telescope = require('telescope')
    local action_set = require('telescope.actions.set')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        mappings = { n = { ['<C-q>'] = actions.smart_send_to_qflist } },
      },
      pickers = {
        find_files = {
          attach_mappings = function()
            action_set.select:enhance({
              post = function()
                vim.cmd(':normal! zx')
              end,
            })
            return true
          end,
        },
      },
    })
    require('telescope').load_extension('fzy_native')

    local map = vim.keymap.set
    local builtins = require('telescope.builtin')
    map('n', '<leader>ff', function()
      builtins.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
    end)
    map('n', '<leader>fs', builtins.lsp_document_symbols)
    map('n', '<leader>fk', builtins.lsp_workspace_symbols)
    map('n', '<leader>fg', builtins.live_grep)
    map('n', '<leader>fl', function()
      local str = vim.fn.getline('.')
      -- trim leading and trailing whitespace and escape newlines
      str = str:gsub('^%s*(.-)%s*$', '%1'):gsub('\n', '\\n')
      -- and regex characters including \n, ^, $, ., *, +, ?, (, ), [, ], {, }, |
      str = vim.fn.escape(str, '\\^$.*+?()[]{}|')
      builtins.live_grep({ default_text = str })
    end)
    map('n', '<leader>fw', function()
      builtins.live_grep({ default_text = vim.fn.expand('<cword>') })
    end)
    map('n', '<leader>b', builtins.buffers)
    map('n', '<leader>tt', builtins.builtin)
  end,
}
