--- Check if a file or directory exists in this path
local function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

--- Check if a directory exists in this path
local function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end

local SESSION_DIRECTORY_PATH = os.getenv('HOME')..'/vim-sessions'

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Diffview tabs can't be restored from a session: they come back as empty
-- `diffview://` buffers, and reopening Diffview on the same files then shows blank panes.
local function wipe_diffview_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("^diffview://") then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

if not vim.v.argv[3] then
  -- Obsession fires ObsessionPre right before each save. On the save it makes while
  -- quitting, drop Diffview first so it never lands in the session file.
  vim.api.nvim_create_autocmd("User", {
    pattern = "ObsessionPre",
    callback = function()
      if vim.v.exiting == vim.NIL then return end
      pcall(vim.cmd, "DiffviewClose")
      wipe_diffview_buffers()
    end,
  })

  local currentDirectory = vim.loop.cwd();
  currentDirectory = currentDirectory:gsub("%W", "_")

  if not isdir(SESSION_DIRECTORY_PATH) then
    --- Create directory
    os.execute("mkdir " .. SESSION_DIRECTORY_PATH)
  end

  local sessionPath = SESSION_DIRECTORY_PATH .. '/' .. currentDirectory;

  if (exists(sessionPath)) then
   vim.api.nvim_command('silent source ' .. sessionPath)
   wipe_diffview_buffers()
  end
  vim.api.nvim_command('silent Obsession ' .. sessionPath)
end
  
