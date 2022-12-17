local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  use({
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'p00f/nvim-ts-rainbow',
    'nvim-treesitter/nvim-treesitter-refactor',
    'windwp/nvim-ts-autotag',
    run = ':TSUpdate',
  })
  use('jiangmiao/auto-pairs')
  use('lukas-reineke/indent-blankline.nvim')
  use({
    'andymass/vim-matchup',
    config = function()
      -- disable awkward offscreen matching
      vim.cmd([[let g:matchup_matchparen_offscreen = {}]])
    end,
  })

  use('wellle/targets.vim')

  use({
    'cappyzawa/trim.nvim',
  })

  use('nvim-lua/popup.nvim')
  use('nvim-lua/plenary.nvim')
  use('ThePrimeagen/harpoon')
  use('nvim-telescope/telescope.nvim')
  -- required by lualine and nvim-tree
  use({ 'kyazdani42/nvim-web-devicons', opt = true })
  use('nvim-lualine/lualine.nvim')
  use('folke/which-key.nvim')
  use('tpope/vim-fugitive')
  use('airblade/vim-gitgutter')
  use('tpope/vim-sleuth')
  use('kyazdani42/nvim-tree.lua')

  use({
    'github/copilot.vim',
    config = function()
      vim.cmd([[ let g:copilot_no_tab_map = v:true ]])
    end,
  })

  use('neovim/nvim-lspconfig')
  use({ 'williamboman/mason.nvim' })
  use({ 'williamboman/mason-lspconfig.nvim' })
  use('jose-elias-alvarez/null-ls.nvim')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  -- use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/nvim-cmp')

  use('tpope/vim-surround')
  use('tpope/vim-repeat')

  use('tpope/vim-commentary')
  use({
    'unblevable/quick-scope',
    config = function()
      vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
    end,
  })
  use('haya14busa/vim-asterisk')
  use('mbbill/undotree')

  --colorschemes
  use('bluz71/vim-nightfly-colors')
  use('phanviet/vim-monokai-pro')
  use('morhetz/gruvbox')
  use('haishanh/night-owl.vim')
  use('ayu-theme/ayu-vim')
  use('rakr/vim-one')
  use('hzchirs/vim-material')
  use({ 'ghifarit53/tokyonight-vim', as = 'tokyonight' })
  -- nordfox, dayfox, dawnfox and duskfox
  use('EdenEast/nightfox.nvim')

  if packer_bootstrap then
    print('installing plugins ...')
    require('packer').sync()
  end
end)
