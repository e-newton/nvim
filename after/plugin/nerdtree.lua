require("nvim-tree").setup({
  view = {
    width = 75
  },
  filters = {
    dotfiles = false
  }
})
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>E", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>")

