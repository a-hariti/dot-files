return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
    'onsails/lspkind.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local telescope = require('telescope')
    local action_set = require('telescope.actions.set')
    local actions = require('telescope.actions')
    local lspkind = require('lspkind')
    local entry_display = require('telescope.pickers.entry_display')
    local utils = require('telescope.utils')

    local function lsp_symbols_entry_maker(opts)
      local make_entry = require('telescope.make_entry')
      local original_maker = make_entry.gen_from_lsp_symbols(opts)

      local type_highlight = {
        Class = 'TelescopeResultsClass',
        Constant = 'TelescopeResultsConstant',
        Field = 'TelescopeResultsField',
        Function = 'TelescopeResultsFunction',
        Method = 'TelescopeResultsMethod',
        Property = 'TelescopeResultsOperator',
        Struct = 'TelescopeResultsStruct',
        Variable = 'TelescopeResultsVariable',
      }

      return function(entry)
        local e = original_maker(entry)
        if not e then return e end

        local icon = lspkind.symbolic(e.symbol_type, { mode = 'symbol' })
        local symbol_name = (icon or '') .. ' ' .. e.symbol_name

        if opts.workspace then
          local displayer = entry_display.create({
            separator = ' ',
            items = {
              { width = opts.symbol_width or 30 },
              { remaining = true },
            },
          })

          e.display = function(entry)
            local display_path, path_style = utils.transform_path(opts, entry.filename)
            return displayer({
              symbol_name,
              { display_path, path_style },
            })
          end
        else
          local displayer = entry_display.create({
            separator = ' ',
            items = {
              { width = opts.symbol_width or 30 },
              { remaining = true },
            },
          })

          e.display = function(entry)
            return displayer({
              symbol_name,
              {
                '[' .. entry.symbol_type:lower() .. ']',
                type_highlight[entry.symbol_type] or 'TelescopeResultsVariable',
              },
            })
          end
        end

        return e
      end
    end

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--glob',
          '!.git/*',
          '--glob',
          '!node_modules/*',
        },
        mappings = { n = { ['<C-q>'] = actions.smart_send_to_qflist } },
      },
      pickers = {
        lsp_document_symbols = {
          entry_maker = lsp_symbols_entry_maker({ symbol_width = 40, hidden = true }),
        },
        lsp_workspace_symbols = {
          entry_maker = lsp_symbols_entry_maker({ symbol_width = 40, workspace = true }),
        },
        find_files = {
          attach_mappings = function()
            action_set.select:enhance({
              post = function() vim.cmd(':normal! zx') end,
            })
            return true
          end,
        },
      },
    })
    require('telescope').load_extension('fzy_native')

    local map = vim.keymap.set
    local builtins = require('telescope.builtin')

    -- Primary shortcuts
    local find_files = function() builtins.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } }) end
    map('n', '<D-p>', find_files)
    map('n', '<leader>ff', find_files)
    map('n', 'g/', builtins.live_grep)
    map('n', 'gs', builtins.lsp_document_symbols, { noremap = true })
    map('n', 'gS', builtins.lsp_workspace_symbols, { noremap = true })

    -- Helper mappings
    map('n', '<leader>fl', function()
      local str = vim.fn.getline('.')
      -- trim leading and trailing whitespace and escape newlines
      str = str:gsub('^%s*(.-)%s*$', '%1'):gsub('\n', '\\n')
      -- and regex characters including \n, ^, $, ., *, +, ?, (, ), [, ], {, }, |
      str = vim.fn.escape(str, '\\^$.*+?()[]{}|')
      builtins.live_grep({ default_text = str })
    end)
    map('n', '<leader>fw', function() builtins.live_grep({ default_text = vim.fn.expand('<cword>') }) end)
    map('n', '<leader>b', builtins.buffers)
    map('n', '<leader>tt', builtins.builtin)
  end,
}
