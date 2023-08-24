vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex)


-- Move blocks of code around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-j>", "<C-W><C-J>")
vim.keymap.set("n", "<C-k>", "<C-W><C-K>")
vim.keymap.set("n", "<C-h>", "<C-W><C-H>")
vim.keymap.set("n", "<C-l>", "<C-W><C-L>")

vim.keymap.set("n", "\\", vim.cmd.vsplit)

vim.keymap.set("n", "<leader>tn", function ()
  vim.cmd.tabnew()
end)
vim.keymap.set("n", "<leader>tx", function ()
  vim.cmd.tabclose()
end)
vim.keymap.set("n", "<leader>tl", function ()
  vim.cmd.tabNext()
end)
vim.keymap.set("n", "<leader>th", function ()
  vim.cmd.tabprevious()
end)

vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch)

-- vim.keymap.set("n", "<C-x>", vim.cmd.bdelete)
vim.keymap.set("n", "<leader>bD", function ()
  vim.api.nvim_command('%bd|e#')
end)

vim.keymap.set({'n', 'x'}, '<C-p>', '"0p', {})
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve-r-cr-o:hor30"
