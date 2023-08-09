local treesj = require('treesj');
treesj.setup({
  use_default_keymaps = false,
})
vim.keymap.set({'n'}, "<leader>j", function() treesj.toggle() end)
