-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_augroup("RestoreCursorShapeOnExit", { clear = true })

vim.api.nvim_create_autocmd("VimLeave", {
  group = "RestoreCursorShapeOnExit",
  pattern = "*",
  callback = function()
    vim.opt.guicursor = "a:ver25-blinkwait400-blinkoff400-blinkon400"
  end,
})
local function copy()
  if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
    require("osc52").copy_register("+")
  end
end

vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
