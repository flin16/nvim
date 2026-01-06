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
        -- TODO: add color to it
        { "<leader>y", group = "Yazi", icon = "󰇥" },
      },
      -- name = "\\",
      -- d = { name = "+debug" },
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
  -- TODO: remove this
  -- {
  --   "amitds1997/remote-nvim.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   config = true,
  -- },
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
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
    event = "LspAttach",
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ layout = 2 })
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close({})
      -- end
    end,
  },
  -- TODO: reduce annoying notifications
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
  -- TODO: still need to speed up
  -- {
  --   "flin16/vim-overleaf",
  --   ft = { "bib", "tex", "latex" },
  -- },
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
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    enable = false,
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
  {
    "gbprod/yanky.nvim",
    enabled = vim.env.SSH_CONNECTION == nil,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = true,
    opts = {
      transparent_background = true,
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
  { "mfussenegger/nvim-dap-python", ft = { "python" }, event = "LspAttach" },
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
            -- is_test_file = function(file_path)
            --   ...
            -- end,
            pytest_discover_instances = true,
          }),
        },
      })
    end,
  },
  {
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup()
    end,
  },
}
-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
