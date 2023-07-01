local bufferline = require("bufferline")
local commands = require("bufferline.commands");
local state = require("bufferline.state");
bufferline.setup{
  options = {
    style_preset = bufferline.style_preset.no_italic,
  }
}

vim.keymap.set("n", "<C-x>", function ()
  local current_index, table = commands.get_current_element_index(state)
  print(table.id);
  if current_index == 1 then
    vim.api.nvim_command("BufferLineCycleNext")
    vim.api.nvim_command(string.format("bdelete %d", table.id))
    return;
  end
  vim.api.nvim_command("BufferLineCyclePrev")
  vim.api.nvim_command(string.format("bdelete %d", table.id))
end
)

vim.keymap.set("n", "<A-l>", function ()
  vim.api.nvim_command("BufferLineCycleNext")
end)

vim.keymap.set("n", "<A-h>", function ()
  vim.api.nvim_command("BufferLineCyclePrev")
end)
