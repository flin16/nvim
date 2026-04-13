-- stylua: ignore
return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local path = (vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin/python" or "python")
      require("dap-python").setup(path)
    end,
  },
  {
    "nvim-neotest/neotest-python",
    ft = { "python" },
    dependencies = {
      "nvim-neotest/neotest",
    },
    config = function()
      local test = require("neotest")
      ---@diagnostic disable-next-line: missing-fields
      test.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = "python3",
            pytest_discover_instances = true,
          }),
        },
      })
    end,
  },
}
