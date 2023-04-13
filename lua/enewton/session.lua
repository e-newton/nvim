local group = vim.api.nvim_create_augroup('sessions', {clear = true})
local session_file = "~/.vim-session"
vim.api.nvim_create_autocmd('VimLeavePre', {
  desc= "Function run on vim close",
  group=group,
  callback = function ()
    vim.cmd("mks! " .. session_file)
  end
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc= "Function run on vim enter",
  group=group,
  nested=true,
  callback = function ()
    if vim.fn.filereadable(session_file) then
      vim.cmd.source(session_file)
    end
  end
})
