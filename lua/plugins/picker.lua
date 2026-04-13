-- stylua: ignore
local excluded_list = require("plugins.utils.file_utils")

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>s:",
        require("utils.pickers").history,
        desc = "Picker History",
      },
    },
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = excluded_list,
          },
          explorer = {
            ignored = true,
            exclude = excluded_list,
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                width = function()
                  return math.floor(vim.o.columns * 0.35)
                end,
                min_width = 30,
              },
            },
          },
        },
      },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>yy",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>yY",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>yt",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
