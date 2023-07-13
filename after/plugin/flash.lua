local flash = require('flash');
flash.setup();
vim.keymap.set({'n', 'x', 'o'}, "s", function() flash.jump() end)
vim.keymap.set({'n', 'x', 'o'}, "S", function() flash.treesitter({}) end)
vim.keymap.set({'o'}, "r", function() flash.remote() end)
vim.keymap.set({'o'}, "R", function() flash.tressitter_search() end)
vim.keymap.set({'o'}, "<c-s>", function() flash.toggle() end)
