-- stylua: ignore
local excluded_list = require("plugins.utils.file_utils")

return {
  {
    "LazyVim/LazyVim",
    opts = {
      kind_filter = { tex = true },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<localleader>c", group = "code", mode = { "n", "v" } },
        { "<localleader>d", group = "debug", mode = { "n", "v" } },
        { "<localleader>r", icon = "󰑕", group = "Rename (COC)" },
        { "<leader>a", group = "AI", mode = { "n", "v" } },
        { "<leader>y", group = "Yazi", icon = { icon = "󰇥", color = "orange" } },
        { "<leader>U", icon = "↩", group = "Undotree" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        tex = { "chktex" },
      },
    },
    config = function()
      require("lint").linters.ruff.args = { "--ignore=E401" }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        sh = { "shfmt" },
        lua = { "stylua" },
        tex = { "latexindent" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.b.coc_suggest_disable = true
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "kdheepak/cmp-latex-symbols" },
    },
    sources = {
      {
        name = "latex_symbols",
        option = {
          strategy = 0, -- mixed
        },
      },
    },
  },
  {
    "gbprod/yanky.nvim",
    enabled = vim.env.SSH_CONNECTION == nil,
  },
  -- TODO: make this work
  -- {
  --   "antosha417/nvim-lsp-file-operations",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("lsp-file-operations").setup()
  --   end,
  -- },
}
