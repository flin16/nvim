if vim.g.disable_math then
  return {}
end

return {
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build", -- use a separate build directory
        callback = 1, -- enable callback
        continuous = 1, -- enable continuous compilation
        options = {
          "-pdf", -- use pdf output
          "-shell-escape", -- enable shell escape
          "-verbose", -- verbose output
          "-file-line-error", -- file line error messages
        },
      }
      vim.g.vimtex_syntax_custom_cmds = {
        { name = "mb", mathmode = 1, argstyle = "bold", conceal = 1 },
        { name = "mf", mathmode = 1, argstyle = "boldital", conceal = 1 },
        { name = "mc", mathmode = 1, argstyle = "ital", conceal = 1 },
        { name = "mk", mathmode = 1, argstyle = "bold", conceal = 1 },
      }
    end,
  },
  {
    "latex-lsp/texlab",
  },
  { "HakonHarnes/img-clip.nvim", ft = { "markdown", "tex" } },
  {
    "pxwg/math-conceal.nvim",
    event = "VeryLazy",
    build = "make lua51",
    main = "math-conceal",
    opts = {
      enabled = true,
      conceal = {
        "greek",
        "script",
        "math",
        "font",
        "delim",
        "phy",
      },
      ft = { "*.tex", "*.md", "*.typ" },
    },
  },
}
