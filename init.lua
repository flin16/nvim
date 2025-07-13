-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.debugger").setup()
local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
if file_exists(vim.fn.stdpath("config") .. "/lua/config/local.lua") then
  require("config.local")
end
