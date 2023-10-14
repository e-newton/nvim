require('lspsaga').setup({})
local opts = { remap = false, silent = true }
vim.keymap.set("n", "<leader>a", ":Lspsaga code_action<CR>", opts)
vim.keymap.set("n", "<leader>rn", ":Lspsaga rename<CR>", opts)
vim.keymap.set("i", "<C-k>", ":Lspsaga signature_help<CR>", opts)
