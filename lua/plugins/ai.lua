if vim.g.disable_ai then
  return {}
end
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
      keymap = {
        accept = false, -- handled by blink
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "j-hui/fidget.nvim",
    },
    config = function()
      require("utils.codecompanion_fidget_spinner"):init()
    end,
    keys = {
      {
        "<leader>ai",
        ":'<,'>CodeCompanion<CR>",
        mode = "v",
        noremap = true,
        silent = true,
        desc = "CodeCompanion inline",
      },
      {
        "<leader>ai",
        ":<Cmd>CodeCompanion<CR>",
        mode = "n",
        noremap = true,
        silent = true,
        desc = "CodeCompanion inline",
      },
    },
    opts = {
      display = {
        diff = {
          enabled = true,
          provider = "mini_diff",
        },
      },
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
      },
      opts = {
        language = "English", -- "English"|"Chinese"
      },
    },
  },
}
