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
    name = "Launch Current Module (Strict)",
    module = function()
      local root_file = vim.fs.find({ ".git", "pyproject.toml", "requirements.txt" }, {
        upward = true,
        path = vim.fn.expand("%:p:h"),
      })[1]

      if not root_file then
        return nil
      end

      local root = vim.fs.dirname(root_file)
      local file = vim.fn.expand("%:p")

      local rel_path = file:sub(#root + 2)

      local module_path = rel_path:gsub("/", "."):gsub("%.py$", "")

      print("Debug: Executing 'python -m " .. module_path .. "'")
      return module_path
    end,
    cwd = function()
      local root_file = vim.fs.find({ ".git", "pyproject.toml" }, { upward = true, path = vim.fn.expand("%:p:h") })[1]
      return root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()
    end,
    console = "integratedTerminal",
  })
end

return M
