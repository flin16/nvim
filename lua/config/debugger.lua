local M = {}
local dap = require("dap")

local MASON_PATH = vim.fn.stdpath("data") .. "/mason"
local BASH_DEBUG_ADAPTER_BIN = MASON_PATH .. "/bin/bash-debug-adapter"
local BASHDB_DIR = MASON_PATH .. "/packages/bash-debug-adapter/extension/bashdb_dir"

function M.setup()
  dap.adapters.sh = {
    type = "executable",
    command = BASH_DEBUG_ADAPTER_BIN,
  }
  dap.configurations.sh = {
    {
      name = "Launch Bash debugger",
      type = "sh",
      request = "launch",
      program = "${file}",
      cwd = "${fileDirname}",
      pathBashdb = BASHDB_DIR .. "/bashdb",
      pathBashdbLib = BASHDB_DIR,
      pathBash = "bash",
      pathCat = "cat",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      env = {},
      args = {},
      -- showDebugOutput = true,
      -- trace = true,
    },
  }
  -- Debug the python module
  table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Launch Module",
    module = function()
      local file = vim.fn.expand("%:p") -- /.../game/unit.py
      local file_dir = vim.fn.fnamemodify(file, ":h") -- /.../game
      local dir_name = vim.fn.fnamemodify(file_dir, ":t") -- game
      local base_name = vim.fn.fnamemodify(file, ":t:r") -- unit
      return dir_name .. "." .. base_name
    end,
    cwd = function()
      return vim.fn.expand("%:p:h:h")
    end,
    console = "integratedTerminal",
  })
end

return M
