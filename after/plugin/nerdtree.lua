require("nvim-tree").setup({

  view = {
    adaptive_size = true
  },
  filters = {
    dotfiles = false
  }
})
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>E", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>")

