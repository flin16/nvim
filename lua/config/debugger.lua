local M = {}

local function find_root(markers, path)
  local root_file = vim.fs.find(markers, { upward = true, path = path })[1]
  return root_file and vim.fs.dirname(root_file) or nil
end

function M.setup()
  local dap = require("dap")
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local bash_adapter = mason_path .. "/bin/bash-debug-adapter"
  local bashdb_dir = mason_path .. "/packages/bash-debug-adapter/extension/bashdb_dir"

  if vim.fn.executable(bash_adapter) == 1 then
    dap.adapters.sh = {
      type = "executable",
      command = bash_adapter,
    }
    dap.configurations.sh = {
      {
        name = "Launch Bash debugger",
        type = "sh",
        request = "launch",
        program = "${file}",
        cwd = "${fileDirname}",
        pathBashdb = bashdb_dir .. "/bashdb",
        pathBashdbLib = bashdb_dir,
        pathBash = "bash",
        pathCat = "cat",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        env = {},
        args = {},
      },
    }
  end

  table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Launch Current Module (Strict)",
    module = function()
      local root = find_root({ ".git", "pyproject.toml", "requirements.txt" }, vim.fn.expand("%:p:h"))
      if not root then
        return nil
      end
      local file = vim.fs.normalize(vim.fn.expand("%:p"))
      local rel_path = file:sub(#root + 2)
      local module_path = rel_path:gsub("\\", "/"):gsub("/", "."):gsub("%.py$", "")
      return module_path
    end,
    cwd = function()
      return find_root({ ".git", "pyproject.toml" }, vim.fn.expand("%:p:h")) or vim.fn.getcwd()
    end,
    console = "integratedTerminal",
  })
end

return M
