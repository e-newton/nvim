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

local SESSION_DIRECTORY_PATH = '/home/enewton/vim-sessions'

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

if not vim.v.argv[3] then
  local currentDirectory = vim.loop.cwd();
  currentDirectory = currentDirectory:gsub("%W", "_")

  if not isdir(SESSION_DIRECTORY_PATH) then
    --- Create directory
    os.execute("mkdir " .. SESSION_DIRECTORY_PATH)
  end

  local sessionPath = SESSION_DIRECTORY_PATH .. '/' .. currentDirectory;

  if (exists(sessionPath)) then
   vim.api.nvim_command('silent source ' .. sessionPath)
  end
  vim.api.nvim_command('silent Obsession ' .. sessionPath)
end
  
