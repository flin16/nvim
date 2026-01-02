-- bootstrap lazy.nvim, LazyVim and your plugins
local function file_exists(name)
  local f = io.open(name, "r")
  if f then
    f:close()
    return true
  else
    return false
  end
end
if file_exists(vim.fn.stdpath("config") .. "/lua/config/local.lua") then
  require("config.local")
end
require("config.lazy")
require("config.debugger").setup()
local project_config = vim.fn.getcwd() .. "/.nvim.lua"
if file_exists(project_config) == 1 then
  dofile(project_config)
end
