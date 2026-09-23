# nvim-config

A personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim), focused on
Python development: LSP-driven editing (basedpyright + ruff), Telescope, neo-tree, a core `nvim-dap`
debugger, gitsigns, and small editor utilities via `mini.nvim` — no completion plugin, no formatter
plugin, no terminal plugin; native Neovim features cover that ground instead. See `CLAUDE.md` for the
full architecture rationale and `KEYBINDINGS.md` for the complete keymap reference.

## Requirements

- **Neovim ≥ 0.11** (built and tested on 0.12.3) — required for the native LSP completion API
  (`vim.lsp.completion`) and the current `vim.lsp.config`/`vim.lsp.enable` API
- **git** — for lazy.nvim's bootstrap clone and gitsigns
- **A C compiler** (`cc`/`gcc`/`clang`) and **`make`** — for compiling treesitter parsers
  (`:TSUpdate`) and building `telescope-fzf-native`
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** (`rg`) — powers Telescope's live grep
- **[fd](https://github.com/sharkdp/fd)** (or `fdfind` on some Linux distros) — used by
  `venv-selector.nvim` to find Python virtual environments
- **A [Nerd Font](https://www.nerdfonts.com/)** in your terminal — for file icons, git status
  symbols, and statusline glyphs (`nvim-web-devicons`, `lualine`, `neo-tree`)
- **Python 3** on `PATH` — only needed if you're editing Python projects (LSP/debugger tooling
  itself is installed and managed by Mason, see below)

## Install

1. Back up any existing config:
   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   ```
2. Clone this repo into place:
   ```sh
   git clone https://github.com/DonikHronic/nvim-config.git ~/.config/nvim
   ```
3. Launch Neovim:
   ```sh
   nvim
   ```
   On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself (clones into
   its data directory) and installs every plugin automatically. Mason then installs the configured
   LSP servers and debug adapter in the background. This can take a minute or two — watch the
   `:Lazy` and `:Mason` UIs if you want to see progress, or just wait for both to settle.
4. Restart Neovim once everything finishes installing, so LSP servers attach cleanly.

## What gets installed automatically

- **Plugins** (via lazy.nvim, pinned in `lazy-lock.json`): see `lua/plugins/*.lua`, one file per
  feature area (LSP, debugging, git, editor utilities, etc.)
- **LSP servers / tools** (via Mason, configured in `lua/plugins/lsp.lua`):
  `basedpyright`, `ruff`, `lua_ls`, `debugpy`

Nothing else needs manual setup — no dotfiles to symlink beyond this directory itself, no extra
package installs beyond the requirements above.

## Useful commands

| Command | What it does |
|---|---|
| `:Lazy` | Plugin manager UI — install/update/clean plugins |
| `:Lazy sync` | Install + update + remove unused plugins in one go |
| `:Mason` | LSP/DAP installer UI |
| `:checkhealth` | Diagnose a broken install (LSP, treesitter, clipboard, etc.) |
| `:TSUpdate` | Rebuild treesitter parsers (run this if syntax highlighting looks broken) |

## Keybindings

Leader key is `\`. The full reference — navigation, Telescope, git, debugging, and everything
else — lives in [`KEYBINDINGS.md`](./KEYBINDINGS.md). Press `<Space>` and wait a moment in Neovim
for a live which-key popup of available bindings.

## Customizing

- `lua/vim-options.lua` — raw editor settings (indentation, search, appearance, etc.)
- `lua/plugins/` — one file per plugin/feature area; drop a new file here to add a plugin, no
  central registry to update (see `CLAUDE.md` for how lazy.nvim discovers them)
- `lua/config/lazy.lua` — lazy.nvim bootstrap and setup, rarely needs touching

If you're using an AI coding assistant (Claude Code, etc.) to modify this config, read `CLAUDE.md`
first — it documents non-obvious cross-plugin wiring (load-order dependencies, why certain options
are set the way they are) that isn't visible from any single file.
