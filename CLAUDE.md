# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration at `~/.config/nvim`, built on LazyVim with lazy.nvim as the plugin manager. The repository tracks dotfile-style config rather than a reusable project.

## Architecture

```
lua/config/    # Core Neovim config (options, keymaps, LSP, DAP, autocmds, plugin bootstrap)
lua/plugins/   # lazy.nvim plugin specs (each file returns a table of plugin specs)
lua/utils/     # Custom Lua modules (pickers, fidget spinner for CodeCompanion)
lazyvim.json   # LazyVim extras/modules enabled
stylua.toml    # Lua formatter config (2-space indent, 120 col)
```

`lua/config/lazy.lua` bootstraps lazy.nvim and loads both LazyVim plugins and local `plugins/` specs.

## Feature Flags

Set in `lua/config/flags.lua` before any plugin loads:
- `vim.g.disable_ai` — disable CodeCompanion + Copilot
- `vim.g.disable_math` — disable VimTeX + texlab + img-clip
- `vim.g.disable_debug_ui` — disable dap-ui
- `vim.g.disable_fancy_ui` — disable catppuccin + marks.nvim

## Key Plugin Specs

- `lua/plugins/basic.lua` — LSP (pyright), linting (shellcheck, chktex, ruff), formatting (black, shfmt, stylua, latexindent), cmp, yanky, which-key
- `lua/plugins/ai.lua` — copilot.lua + CodeCompanion.nvim
- `lua/plugins/math.lua` — vimtex + texlab + img-clip.nvim, `<localleader>lM` to set main tex file
- `lua/plugins/debug.lua` — dap-ui
- `lua/plugins/ui.lua` — molokai, catppuccin, marks.nvim
- `lua/plugins/picker.lua` — snacks.nvim (picker), yazi.nvim
- `lua/plugins/editing.lua` — undotree, tiny-code-action.nvim
- `lua/plugins/testing.lua` — dap-python, neotest-python
- `lua/plugins/utils.lua` — tmux.nvim, bufresize.nvim

## Notable Customizations

**Clipboard behavior**: Deleted/changed text goes to register `1` (secondary) to avoid clobbering the primary clipboard. `<D-v>` pastes from system clipboard, `<D-c/x>` copy/cut to system clipboard.

**DAP config** (`lua/config/debugger.lua`): Adds a "Launch Current Module (Strict)" Python config that resolves the project root from `.git`/`pyproject.toml` and strips the root prefix from the file path to produce a proper module path. Also adds bash debugger config via mason-installed bash-debug-adapter.

**VimTeX** (`lua/plugins/math.lua`): Uses `nvr` (neovim-remote) for forward sync with Skim PDF viewer. Build output goes to `build/` directory. Custom math commands defined: `\mb`, `\mf`, `\mc`, `\mk`.

**Neovide**: Runs with `--listen /tmp/nvimsocket` for reverse search integration with skim.

## Keybindings

| Key | Action |
|-----|--------|
| `<F5>`/`<F6>` | DAP continue / run last |
| `<F10>`/`<F11>`/`<F12>` | DAP step over / into / out |
| `<leader>dv` | Toggle DAP virtual text |
| `<leader>dr` | Toggle DAP REPL |
| `<localleader>b` | DAP toggle breakpoint |
| `<leader>U` | Toggle undotree |
| `<leader>yy`/`<leader>yY` | Yazi at current file / cwd |
| `<leader>yt` | Resume yazi session |
| `<leader>ai` | CodeCompanion inline (normal/visual) |
| `<leader>s:` | Picker history |
| `<D-*>` | MacOS shortcuts (save, close tab, undo, copy/cut/paste) |

## Formatters & Linters

Configured via `nvim-lint` and `conform.nvim`:
- Python: `ruff` (lint, ignoring E401), `black` (format)
- Shell: `shellcheck` (lint), `shfmt` (format)
- Lua: `stylua`
- LaTeX: `latexindent` (format), `chktex` (lint)

## Testing

Neotest with pytest runner for Python. Run via `require("neotest").run.run()` with the pytest adapter configured for `python3`.
