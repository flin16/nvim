-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local keyset = vim.keymap.set

-- Fundamental changes to vanilla Vim behavior.
keyset({"n", "v"}, "c", '"1c')
keyset({"n", "v"}, "C", '"1C')
keyset({"n", "v"}, "x", '"1x')
keyset({"n", "v"}, "X", '"1X')
keyset("n", "<BS>", '"_d')
keyset("o", "<BS>", "d")
keyset("v", "<Del>", '"1d')
keyset({"x", "v"}, "<BS>", '"_x')
keyset({"n", "v"}, "Q", "<Cmd>quit<CR>", { silent = true })

-- DAP keymaps
if pcall(require, "dap") then
  keyset({"n", "v", "i", "t"}, "<F5>", function()
    require("dap").continue()
  end)
  keyset({"n", "v", "i", "t"}, "<F6>", function()
    require("dap").run_last()
  end)
  keyset({"n", "v", "i", "t"}, "<F10>", function()
    require("dap").step_over()
  end)
  keyset({"n", "v", "i", "t"}, "<F11>", function()
    require("dap").step_into()
  end)
  keyset({"n", "v", "i", "t"}, "<F12>", function()
    require("dap").step_out()
  end)
  keyset("n", "<leader>dv", "<Cmd>DapVirtualTextToggle<CR>")
  keyset("n", "<localleader>b", function()
    require("dap").toggle_breakpoint()
  end)
  if pcall(require, "dapui") then
    keyset("n", "<leader>dr", function()
      if require("dapui.windows").layouts[2]:is_open() then
        require("dapui").close({ layout = 2 })
      else
        require("dapui").open({ layout = 2 })
      end
    end)
  end
end

-- Coc.nvim keymaps
keyset("n", "<localleader>r", "<Plug>(coc-rename)")
keyset("v", "<localleader>r", "<Plug>(coc-codeaction-refactor-selected)")
keyset("n", "<localleader>cl", "<Plug>(coc-codelens-action)")
keyset("n", "<localleader>ca", "<Plug>(coc-codeaction)")
keyset("v", "<localleader>ca", "<Plug>(coc-codeaction-selected)")

-- Resolve Coc conflicting keymaps
keyset({"i", "c"}, "<C-a>", "<C-o>^")
keyset({"i", "c"}, "<C-e>", "<C-o>$")

-- MacOS shortcuts
keyset("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keyset("n", "<c-n>", "<Plug>(YankyNextEntry)")
keyset({"n", "v", "i", "t"}, "<D-s>", "<Cmd>w<CR>")
keyset({"n", "v", "i", "t"}, "<D-w>", function()
  local ok = pcall(vim.cmd, "tabclose")
  if not ok then
    vim.notify("Cannot close the last tab page", vim.log.levels.WARN)
  end
end)
keyset({"n", "v", "i", "t"}, "<D-z>", "<Cmd>undo<CR>")
keyset("i", "<D-v>", '<C-O>"+P')
keyset("c", "<D-v>", "<C-R>+")
keyset("n", "<D-v>", '"+p')
keyset("v", "<D-v>", '"1d"+gP')
keyset("v", "<D-c>", '"+y')
keyset("v", "<D-x>", '"+d')
keyset({"n", "v"}, "<D-a>", "gg<S-v>G")