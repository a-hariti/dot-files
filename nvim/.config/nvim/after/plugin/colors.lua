vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = 'original'
vim.cmd.colorscheme('gruvbox-material')

-- change the default error virtual text color
vim.cmd([[ hi link DiagnosticVirtualTextError DiagnosticError ]])
