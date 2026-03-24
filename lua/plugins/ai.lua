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
    init = function()
      -- TODO: fix this
      require("utils.codecompanion_fidget_spinner"):init()
    end,
    keys = {
      {
        "<leader>aa",
        "<CMD>CodeCompanionActions<CR>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion actions",
      },
      -- Map <leader>ai to run CodeCompanion on the selected range in normal and visual modes
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
      {
        "<leader>ac",
        "<CMD>CodeCompanionChat Toggle<CR>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion chat (toggle)",
      },
      {
        "<leader>ap",
        "<CMD>CodeCompanionChat Add<CR>",
        mode = { "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion chat add code",
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
