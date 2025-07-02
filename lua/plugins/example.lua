-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
local excluded_list = {
  "*.pdf", "*.aux", "*.bbl", "*.bcf", "*.blg", "*.fdb_latexmk", "*.fls", "*.log", "*.pdf", "*.run%.xml",
  "*.synctex%.gz", "*.out", "*.toc", "*.pyc", "*.pyo", "*.gz", "*.DS_Store", "*.zip",
  "__pycache__",
  "venv",
  ".git",
}
return {
  {
    "LazyVim/LazyVim",
    opts = {
      kind_filter = { tex = true },
    },
  },
  {
    "tomasr/molokai", -- colorscheme
    -- config = function()
    --   vim.cmd.colorscheme("molokai")
    -- end,
  },
  {
    "folke/which-key.nvim",
    -- TODO: Try to use this without warning
    opts = {
      spec = {
        { "<localleader>c", group = "code", mode = { "n", "v" } },
        { "<localleader>d", group = "debug", mode = { "n", "v" } },
        { "<localleader>r", icon = "󰑕", group = "Rename (COC)" },
        { "<leader>a", group = "AI", mode = { "n", "v" } },
      },
      -- name = "\\",
      -- d = { name = "+debug" },
    },
  },
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
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        tex = { "chktex" },
      },
    },
    config = function()
      local lint = require("lint")
      lint.linters.ruff.args = { "--ignore=E401" }
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
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require("dap")
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          console = "integratedTerminal",
          program = "${file}",
          pythonPath = function()
            return "python"
          end,
        },
      }
    end,
  },
  {
    "amitds1997/remote-nvim.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },
  {
    "folke/snacks.nvim",
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
          },
        },
      },
    },
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    requires = {
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
    "latex-lsp/texlab",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- This would make dapui exit too early
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  -- TODO: reduce annoying notifications
  { "HakonHarnes/img-clip.nvim" },
  -- TODO: test this
  { "petertriho/nvim-scrollbar" },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },

      -- optional picker via telescope
      { "nvim-telescope/telescope.nvim" },
      -- optional picker via fzf-lua
      { "ibhagwan/fzf-lua" },
      -- .. or via snacks
      {
        "folke/snacks.nvim",
        opts = {
          terminal = {},
        },
      },
    },
    event = "LspAttach",
    opts = {},
  },
  {
    "flin16/vim-overleaf",
    ft = { "bib", "tex", "latex" },
  },
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
    dependencies = {
      "j-hui/fidget.nvim",
    },
    init = function()
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
        "<CMD>'<,'>CodeCompanion<CR>",
        mode = { "n", "v" },
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
        delete_buf = "dm<space>",
        preview = "m:",
        delete = "dm",
        delete_bookmark = "dm=",
        next = "]`",
        prev = "[`",
        -- TODO: This seems not working
        -- annotate = "m*",
      },
    },
  },
  { "rachartier/tiny-code-action.nvim" },
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    init = function()
      LazyVim.on_very_lazy(function()
        -- register the formatter with LazyVim
        LazyVim.format.register({
          name = "none-ls.nvim",
          priority = 1, -- set higher than conform, the builtin formatter
          primary = true,
          format = function(buf)
            return LazyVim.lsp.format({
              bufnr = buf,
              filter = function(client)
                return client.name == "null-ls"
              end,
            })
          end,
          sources = function(buf)
            local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or {}
            return vim.tbl_map(function(source)
              return source.name
            end, ret)
          end,
        })
      end)
    end,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- nls.builtins.formatting.fish_indent,
        -- nls.builtins.diagnostics.fish,
        -- nls.builtins.formatting.stylua,
        -- nls.builtins.formatting.shfmt,
      })
    end,
  },
}
-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
