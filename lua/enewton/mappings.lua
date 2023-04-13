vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)


-- Move blocks of code around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-j>", "<C-W><C-J>")
vim.keymap.set("n", "<C-k>", "<C-W><C-K>")
vim.keymap.set("n", "<C-h>", "<C-W><C-H>")
vim.keymap.set("n", "<C-l>", "<C-W><C-L>")

vim.keymap.set("n", "\\", vim.cmd.vsplit)
