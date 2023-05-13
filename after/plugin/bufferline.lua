local bufferline = require("bufferline")
bufferline.setup{
  options = {
    style_preset = bufferline.style_preset.no_italic,
  }
}

vim.keymap.set("n", "<A-l>", function ()
  vim.api.nvim_command("BufferLineCycleNext")
end)

vim.keymap.set("n", "<A-h>", function ()
  vim.api.nvim_command("BufferLineCyclePrev")
end)
