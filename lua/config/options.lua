-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.fn.has("gui_running") == 1 then
  vim.o.clipboard = ""
elseif vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WSL clipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = "powershell.exe -NoProfile -Command Get-Clipboard",
      ["*"] = "powershell.exe -NoProfile -Command Get-Clipboard",
    },
    cache_enabled = 0,
  }
  vim.opt.fileformat = "unix"
elseif vim.env.SSH_CONNECTION or vim.env.WEZTERM_PANE then
  vim.o.clipboard = "unnamedplus"
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end
vim.g.copilot_no_tab_map = true
vim.o.guifont = "Monaco:h16"
vim.cmd("set wrap")
