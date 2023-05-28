vim.cmd([[ let g:copilot_no_tab_map = v:true ]])

local opts = { expr = true, script = true, replace_keycodes = false }

vim.keymap.set('i', '<C-j>', 'copilot#Next()', opts)
vim.keymap.set('i', '<C-k>', 'copilot#Previous()', opts)
vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', opts)
vim.keymap.set('i', '<C-x>', 'copilot#Dismiss()', opts)
