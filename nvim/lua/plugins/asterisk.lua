return {
  'haya14busa/vim-asterisk',
  event = 'BufReadPost',
  config = function()
    local map = vim.keymap.set
    map({ 'n', 'v' }, '*', '<Plug>(asterisk-z*)')
    map({ 'n', 'v' }, 'g*', '<Plug>(asterisk-gz*)')
    map({ 'n', 'v' }, '#', '<Plug>(asterisk-z#)')
    map({ 'n', 'v' }, 'g#', '<Plug>(asterisk-gz#)')
  end,
}
