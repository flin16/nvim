-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.debugger").setup()
if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/config/local.lua") then
  require("config.local")
end
local project_config = vim.fn.getcwd() .. "/.nvim.lua"
if vim.fn.filereadable(project_config) == 1 then
  dofile(project_config)
end
