if vim.g.disable_math then
  return {}
end

return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_latexmk_progname = "nvr"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
        callback = 1,
        continuous = 1,
        options = {
          "-pdf",
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
        },
      }
      vim.g.vimtex_compiler_tectonic = {
        options = { "--synctex" },
      }
      vim.g.vimtex_syntax_custom_cmds = {
        { name = "mb", mathmode = 1, argstyle = "bold", conceal = 1 },
        { name = "mf", mathmode = 1, argstyle = "boldital", conceal = 1 },
        { name = "mc", mathmode = 1, argstyle = "ital", conceal = 1 },
        { name = "mk", mathmode = 1, argstyle = "bold", conceal = 1 },
      }

      local function set_vimtex_main()
        local tex_file = vim.fn.expand("%:p:r")
        local root = vim.fs.root(vim.fn.expand("%:p:h"), { ".git", ".latexmain" })
        if not root then
          root = vim.fn.expand("%:p:h")
        end
        local marker = root .. "/.latexmain"
        local name = vim.fn.fnamemodify(tex_file, ":t")
        vim.fn.writefile({ name }, marker)

        local method = "latexmk"
        if vim.fn.executable("tectonic") == 1 then
          method = "tectonic"
        end
        vim.g.vimtex_compiler_method = method

        vim.cmd([[call vimtex#compiler#stop()]])
        vim.cmd([[call vimtex#compiler#init_state(b:vimtex)]])

        vim.notify("Main: " .. name .. " | Compiler: " .. method, vim.log.levels.INFO)
      end

      vim.keymap.set("n", "<localleader>lM", set_vimtex_main, { buffer = true })
    end,
  },
  { "latex-lsp/texlab" },
  { "HakonHarnes/img-clip.nvim", ft = { "markdown", "tex" } },
}
