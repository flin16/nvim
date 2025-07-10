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
end

return M
