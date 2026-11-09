-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup lives in after/plugin/*.lua, so everything loads at startup (no lazy-loading).
require("lazy").setup({
  spec = {
    {
      "nvim-telescope/telescope.nvim",
      version = "*",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
    },
    { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
    { "williamboman/mason.nvim", build = ":MasonUpdate" },

    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      dependencies = {
        -- LSP Support
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        -- Snippets
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
      },
    },
    {
      "nvimtools/none-ls.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
    },
    "nvimdev/lspsaga.nvim",
    {
      "danymat/neogen",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Git
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "lewis6991/gitsigns.nvim",
    "aaronhallaert/advanced-git-search.nvim",
    { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "akinsho/git-conflict.nvim", version = "*" },

    -- Editing
    "tpope/vim-surround",
    "terrortylor/nvim-comment",
    "folke/flash.nvim",
    "Wansmer/treesj",
    "lukas-reineke/indent-blankline.nvim",
    { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- Navigation / UI
    {
      "aserowy/tmux.nvim",
      config = function()
        local tmux = require("tmux")
        -- Alt-h/l are buffer cycling (bufferline), so resizing lives on Alt-Shift-h/j/k/l.
        -- <C-h/j/k/l> navigation is left to vim-tmux-navigator.
        tmux.setup({
          navigation = { enable_default_keybindings = false },
          resize = { enable_default_keybindings = false },
        })
        vim.keymap.set("n", "<M-H>", tmux.resize_left, { desc = "Resize split left" })
        vim.keymap.set("n", "<M-J>", tmux.resize_bottom, { desc = "Resize split down" })
        vim.keymap.set("n", "<M-K>", tmux.resize_top, { desc = "Resize split up" })
        vim.keymap.set("n", "<M-L>", tmux.resize_right, { desc = "Resize split right" })
      end,
    },
    "christoomey/vim-tmux-navigator",
    "preservim/nerdtree",
    "nvim-tree/nvim-tree.lua",
    "tpope/vim-obsession",
    { "akinsho/bufferline.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    "xiyaowong/transparent.nvim",
    {
      "preservim/vim-markdown",
      init = function()
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_conceal = 0
        vim.g.vim_markdown_no_default_key_mappings = 1
      end,
    },

    -- Colorschemes
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rose-pine/neovim", name = "rose-pine" },
    "sainnhe/everforest",
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
