local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  })
  use('JoosepAlviste/nvim-ts-context-commentstring')

  use({
    'cappyzawa/trim.nvim',
    config = require('trim').setup({}),
  })

  use('nvim-lua/popup.nvim')
  use('nvim-lua/plenary.nvim')
  use('nvim-telescope/telescope.nvim')
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = require('lualine').setup(),
  })
  use({
    'folke/which-key.nvim',
    config = require('which-key').setup({}),
  })
  use('tpope/vim-fugitive')
  use('airblade/vim-gitgutter')
  use('preservim/nerdtree')
  use('Xuyuanp/nerdtree-git-plugin')

  use({
    'github/copilot.vim',
    config = function()
      vim.cmd([[ let g:copilot_no_tab_map = v:true ]])
    end,
  })

  use('neovim/nvim-lspconfig')
  use('williamboman/nvim-lsp-installer')
  use('jose-elias-alvarez/null-ls.nvim')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/nvim-cmp')
  use('ray-x/lsp_signature.nvim')

  use('tpope/vim-surround')
  use('tpope/vim-repeat')

  use('jiangmiao/auto-pairs')
  use('tpope/vim-commentary')
  use({
    'unblevable/quick-scope',
    config = function()
      vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
    end,
  })
  use('haya14busa/vim-asterisk')

  --colorschemes
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
    require('packer').sync()
  end
end)
