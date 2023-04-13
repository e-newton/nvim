local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>p', builtin.git_files, {})
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>lag', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
