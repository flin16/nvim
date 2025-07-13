-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keyset = vim.keymap.set
local function map_nv(lhs, rhs, opts)
  local modes = { "n", "v" }
  for _, mode in ipairs(modes) do
    keyset(mode, lhs, rhs, opts)
  end
end
local function map_all_mode(lhs, rhs, opts)
  map_nv(lhs, rhs, opts)
  keyset("i", lhs, rhs, opts)
  keyset("t", lhs, rhs, opts)
end
-- Very fundamnetal changes for basic vanila Vim. Each change in this section need explanation.
-- Making c key less disruptive to normal coppying and pasting
map_nv("c", '"1c', { desc = "Change and put the deleted part into secondary clipboard" })
map_nv("C", '"1C', { desc = "Change and put the deleted part into secondary clipboard" })
-- Commented otherwise we could not use xp to interchange
map_nv("x", '"1x', { desc = "Delete and put the deleted part into secondary clipboard" })
map_nv("X", '"1X', { desc = "Delete and put the deleted part into secondary clipboard" })
map_nv("<C-d>", '"1d', { desc = "Delete and put the deleted part into secondary clipboard" })
keyset("n", "<BS>", '"1d', { noremap = true, desc = "Backspace in normal mode" })
keyset("o", "<BS>", "d", { noremap = true, desc = "Backspace in normal mode" })
--TODO: This does not work due to which-key
keyset({ "x", "v" }, "<BS>", '"1x', { noremap = true, desc = "Backspace in normal mode" })
-- keyset("v", "x", '"_x', { noremap = true, desc = "Delete without saving to clipboard" })
keyset("n", "Q", function()
  vim.cmd("quit")
end, { noremap = true, silent = true, desc = "Close current window" })
--Config lsp vimtex keymaps
-- TODO: make this workqq
-- vim.keymap.set("n", "<locallleader>ls", function()
--   vim.b.vimtex_main = vim.fn.expand("%:p")
--   vim.cmd("VimtexReloadState")
-- end, { noremap = true, desc = "Set current buffer as vimtex main" })

-- Config Dap keymaps
map_all_mode("<F5>", function()
  require("dap").continue()
end, { desc = "Dap: Continue" })
map_all_mode("<F6>", function()
  require("dap").run_last()
end, { desc = "Dap: Use last config" })
map_all_mode("<F10>", function()
  require("dap").step_over()
end, { desc = "Dap: Step Over" })
map_all_mode("<F11>", function()
  require("dap").step_into()
end, { desc = "Dap: Step Into" })
map_all_mode("<F12>", function()
  require("dap").step_out()
end, { desc = "Dap: Step Out" })
keyset("n", "<leader>dv", function()
  vim.cmd("DapVirtualTextToggle")
end, { desc = "Toggle virtual text of dap" })
keyset("n", "<localleader>b", function()
  require("dap").toggle_breakpoint()
end, { desc = "Dap: Toggle Breakpoint" })
keyset("n", "<localleader>dr", function()
  if require("dapui.windows").layouts[2]:is_open() then
    require("dapui").close({ layout = 2 })
  else
    require("dapui").open({ layout = 2 })
  end
end, { desc = "Dapui: Toggle REPL" })

-- Configure Coc.nvim keymaps
keyset("n", "<localleader>r", "<Plug>(coc-rename)", { desc = "Rename (Coc)" })
keyset("v", "<localleader>r", "<Plug>(coc-codeaction-refactor-selected)", { desc = "Refactor Selected (Coc)" })
keyset("n", "<localleader>cl", "<Plug>(coc-codelens-action)", { desc = "CodeLens Action (Coc)" })
-- Code actions are actually twisted by another plugin
keyset("n", "<localleader>ca", "<Plug>(coc-codeaction)", { desc = "Code Action (Coc)" })
keyset("v", "<localleader>ca", "<Plug>(coc-codeaction-selected)", { desc = "Code Action (Coc)" })

-- Resolve Coc conflicting keymaps
keyset({ "i", "c" }, "<C-a>", "<C-o>^", { desc = "Goto beginning" })
keyset({ "i", "c" }, "<C-e>", "<C-o>$", { desc = "Goto end" })

-- Now configure shortcuts for MacOS
-- if vim.g.neovide then
keyset("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keyset("n", "<c-n>", "<Plug>(YankyNextEntry)")
map_all_mode("<D-s>", "<Cmd>w<CR>") -- Save
map_all_mode("<D-w>", function()
  local success, _ = pcall(function()
    vim.cmd("tabclose")
  end)
  if not success then
    vim.notify("Cannot close the last tab page", vim.log.levels.WARN)
  end
end, { desc = "Close current tab" })
map_all_mode("<D-z>", function()
  vim.cmd("undo")
end)
keyset("i", "<D-v>", '<C-O>"+P')
keyset("c", "<D-v>", "<C-R>+")
keyset("n", "<D-v>", '"+p', { desc = "Paste from clipboard" })
keyset("v", "<D-v>", '"1d"+gP', { desc = "Remove the selected part and paste from system clipboard." })
keyset("v", "<D-c>", '"+y', { desc = "Copy to clipboard in visual mode" })
keyset("v", "<D-x>", '"+d', { desc = "Cut to clipboard" })
map_nv("<D-a>", "gg<S-v>G", { desc = "Select all" })
if vim.env.ALACRITTY_SOCKET then
  keyset("n", "<C-Tab>", ":BufferLineCycleNext<CR>", { silent = true })
  keyset("n", "<C-S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
  keyset("i", "<C-Tab>", function()
    require("copilot.suggestion").accept()
  end, { silent = true, desc = "Copilot Accept Suggestion" })
end
-- Code action menu
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
  ---@diagnostic disable-next-line: missing-parameter
  require("tiny-code-action").code_action()
end, { noremap = true, silent = true })
