-- stylua: ignore
if vim.g.disable_fancy_ui then
  return {}
end
return {
  { "tomasr/molokai" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = false,
      mappings = {
        set = "m",
        set_next = "m,",
        toggle = "m;",
        delete_line = "dm-",
        delete_buf = "dm ",
        preview = "m:",
        delete = "dm",
        delete_bookmark = "dm=",
        next = "]`",
        prev = "[`",
      },
    },
  },
}
