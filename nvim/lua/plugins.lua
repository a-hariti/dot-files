local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(
  function(use)
    use "wbthomason/packer.nvim"

    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    }

    use "mhartington/formatter.nvim"
    use {
      "cappyzawa/trim.nvim",
      config = function()
        require("trim").setup({})
      end
    }

    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"
    use "nvim-telescope/telescope.nvim"
    use "BurntSushi/ripgrep"
    use {
      "nvim-lualine/lualine.nvim",
      requires = {"kyazdani42/nvim-web-devicons", opt = true},
      config = require("lualine").setup()
    }
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }
    use "tpope/vim-fugitive"
    use "airblade/vim-gitgutter"
    use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons" -- optional, for file icon
      },
      config = function()
        vim.g.nvim_tree_width = 25
        vim.g.nvim_tree_indent_markers = 1
        require "nvim-tree".setup {
          auto_open = 0,
          auto_close = 1,
          actions = {
            open_file = {quit_on_open = false}
          }
        }
      end
    }

    use {
      "neovim/nvim-lspconfig",
      "williamboman/nvim-lsp-installer"
    }
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/nvim-cmp"
    use "ray-x/lsp_signature.nvim"

    use "tpope/vim-surround"
    use "tpope/vim-repeat"

    use "jiangmiao/auto-pairs"
    use "tpope/vim-commentary"
    use {
      "unblevable/quick-scope",
      config = function()
        vim.g.qs_highlight_on_keys = {"f", "F", "t", "T"}
      end
    }
    use "haya14busa/vim-asterisk"

    --colorschemes
    use "phanviet/vim-monokai-pro"
    use "morhetz/gruvbox"
    use "haishanh/night-owl.vim"
    use "ayu-theme/ayu-vim"
    use "rakr/vim-one"
    use "hzchirs/vim-material"
    use {"ghifarit53/tokyonight-vim", as = "tokyonight"}

    if packer_bootstrap then
      require("packer").sync()
    end
  end
)
