-- Reuse git info from gitsigns.nvim
-- https://github.com/nvim-lualine/lualine.nvim/issues/699
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end
return {
  'nvim-lualine/lualine.nvim',
  event = 'BufWinEnter',
  config = function()
    require('lualine').setup({
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', { 'diff', source = diff_source }, 'diagnostics' },
        lualine_c = {
          { 'filename', path = 1 },
          {
            function()
              return require('nvim-navic').get_location()
            end,
            cond = function()
              return require('nvim-navic').is_available()
            end,
          },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      options = { section_separators = '', component_separators = '' },
    })
  end,
}
