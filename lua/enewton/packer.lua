-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = {
      {'nvim-lua/plenary.nvim'},
      { "nvim-telescope/telescope-live-grep-args.nvim" }
    },
    config = function ()
      require("telescope").load_extension("live_grep_args")
    end
  }

  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use ({
    "williamboman/mason.nvim",
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  })

  use("tpope/vim-fugitive")
  use("sainnhe/everforest")

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }
  use("lukas-reineke/indent-blankline.nvim")
  use("tpope/vim-rhubarb")
  use("tpope/vim-surround")
  use {
  'lewis6991/gitsigns.nvim',
   tag = 'release'
  }
  use {
  "folke/trouble.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  }
  use("jose-elias-alvarez/null-ls.nvim")
  use("terrortylor/nvim-comment")
  use({
    "aserowy/tmux.nvim",
    config = function() return require("tmux").setup() end
  })
  use("christoomey/vim-tmux-navigator")
  use("preservim/nerdtree")
  use("nvim-tree/nvim-tree.lua")
  use("tpope/vim-obsession")
  use({
    "akinsho/bufferline.nvim",
    branch = 'main',
    -- some optional icons
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  })
  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use("xiyaowong/transparent.nvim");
  use("folke/flash.nvim");
  use("Wansmer/treesj");
  use("catppuccin/nvim");
  use("f-person/git-blame.nvim");
  use {
    "danymat/neogen",
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  }
  use({
    "aaronhallaert/advanced-git-search.nvim",
})
use {'akinsho/git-conflict.nvim', tag = "*", config = function()
  require('git-conflict').setup()
end}
use({ 'rose-pine/neovim', as = 'rose-pine' })


end)

