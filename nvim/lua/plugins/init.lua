return {
  'nvim-lua/plenary.nvim',
  { 'nvim-tree/nvim-web-devicons' },
  { 'tpope/vim-fugitive', cmd = 'Git' },
  -- 'elixir-tools/elixir-tools.nvim',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'mbbill/undotree',
  'bluz71/vim-nightfly-colors',
  'phanviet/vim-monokai-pro',
  'sainnhe/gruvbox-material',
  'haishanh/night-owl.vim',
  'ayu-theme/ayu-vim',
  'rakr/vim-one',
  'hzchirs/vim-material',
  { 'ghifarit53/tokyonight-vim', name = 'tokyonight' },
  'EdenEast/nightfox.nvim',
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'projekt0n/github-nvim-theme' },
  'stevearc/dressing.nvim',
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = 'skim'
    end,
  },
}
