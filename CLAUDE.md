# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration, built with lazy.nvim, kept deliberately minimal: LSP-driven Python
editing (basedpyright + ruff), Telescope, neo-tree, a core `nvim-dap` debugger, gitsigns for inline
hunk/blame, `mini.nvim` for small editor utilities (pairs/comment/surround/indentscope), and native
(plugin-free) LSP completion plus a vanilla terminal toggle. There is no application code, build step,
or test suite — "development" here means editing Lua config files and validating the result inside a
running Neovim instance.

## Commands

There is no build/lint/test tooling for this repo itself. The relevant commands all run *inside Neovim*:

- `:Lazy` — open the plugin manager UI (install/update/clean plugins)
- `:Lazy sync` — install + update + remove unused plugins in one go
- `:Lazy clean` — uninstall plugins no longer referenced by any spec (run after deleting a plugin file)
- `:Lazy U` — update all plugins (writes `lazy-lock.json` — commit that file when intentionally bumping versions)
- `:Mason` — open the LSP/DAP installer UI (manages basedpyright, ruff, lua_ls, debugpy)
- `:checkhealth` — diagnose a broken config (LSP, treesitter, clipboard, etc.)
- `:source %` or restart Neovim — reload after editing a Lua file (most `config` functions only run once at startup)

When testing a config change, launch `nvim` from the terminal against a scratch file/project rather than
trying to reason about it statically — plugin `config` functions, `LspAttach` autocmds, and lazy-loading
`event`/`ft` triggers all have runtime effects that are easy to get wrong by inspection alone.

## Architecture

**Load order** (`init.lua`): `lua/vim-options.lua` (raw `vim.opt`/`vim.cmd` settings, leader key) is
required first, then `lua/config/lazy.lua`, which bootstraps lazy.nvim (clones it if missing) and calls
`require("lazy").setup("plugins", ...)`.

**Plugin discovery is directory-based, not an explicit list.** `lazy.setup("plugins", ...)` imports every
file under `lua/plugins/` automatically; there's no central registry to edit when adding a plugin — just
drop a new file (or a table entry in an existing one) into `lua/plugins/`. Each file returns either a
single lazy.nvim plugin spec or an array of specs, and is organized **by feature/concern**, not
one-file-per-plugin (e.g. `lsp.lua` holds Mason + mason-lspconfig + mason-tool-installer + nvim-lspconfig
together since they're one pipeline). `editor.lua` bundles `mini.nvim` (pairs/comment/surround/
indentscope modules, one dependency-free library instead of four separate small plugins) with
`which-key`.

**There is intentionally no formatter, completion plugin, terminal plugin, LazyGit UI, or
diagnostics-panel plugin.** These were removed to cut the config back to what's actually used — don't
reintroduce `conform.nvim`, `nvim-cmp`, `toggleterm.nvim`, `lazygit.nvim`, or `trouble.nvim` without being
asked; native equivalents already cover the same ground (see below). `gitsigns.nvim` **is** present
(hunk gutter/blame only, not a full git UI — that's still Telescope's job).

**Cross-plugin wiring to know about before touching any one file:**
- **Completion is native, not a plugin**: `lsp.lua`'s `LspAttach` autocmd calls
  `vim.lsp.completion.enable(true, event.data.client_id, buf, { autotrigger = true })` per-buffer —
  this is what makes the completion popup appear, not a `nvim-cmp` config. `vim-options.lua`'s
  `completeopt = { "menu", "menuone", "noselect" }` is required for that popup to behave correctly.
- **No format-on-save or format command exists.** Ruff's LSP diagnostics stay enabled but its hover is
  disabled (`client.server_capabilities.hoverProvider = false` in `lsp.lua`) since `basedpyright` owns
  hover; formatting itself is left to external tools (`ruff format` from a terminal, etc.).
- **Mason installs binaries other configs consume by path**: `debugging.lua` locates debugpy at
  `stdpath("data")/mason/packages/debugpy/venv/bin/python` rather than on `$PATH`. `lsp.lua`'s
  `mason-lspconfig` / `mason-tool-installer` blocks are the source of truth for what's installed
  (`basedpyright`, `ruff`, `lua_ls`, `debugpy`).
- **`vim.lsp.config()` / `vim.lsp.enable()`** (Neovim ≥0.11 native LSP API) is used directly in `lsp.lua`
  instead of the older `lspconfig.setup{}` per-server calls — keep new servers consistent with that style.
- **`queries/markdown/injections.scm` is a deliberate user-level override, not a stray file**: it exists
  purely to shadow `nvim-treesitter`'s own (frozen-`master`) markdown injection query, whose custom
  `#set-lang-from-info-string!` directive crashes on this Neovim version (`match[capture_id]` is now a
  node list, not a single node, in newer core — the directive predates that API change). The override is
  Neovim core's own simpler injections.scm, copied in verbatim. It works *because* this config's own root
  is earlier on `runtimepath` than lazy-installed plugins, and `vim.treesitter.query.get_files()` picks
  the **first** non-`; extends` match as the base query — `after/queries/...` does **not** work for this,
  since `after/` sorts last. Delete this file only once `nvim-treesitter` is migrated off legacy `master`.
- **Debugging is core-only**: `debugging.lua` wires `nvim-dap` + `nvim-dap-python` for breakpoints,
  step/continue, and the REPL (`dap.repl.open`) — there is no `nvim-dap-ui` panel and no inline
  virtual-text values; inspect state via `<leader>dr` (REPL) instead.
- **venv-selector → LSP restart**: `venv-selector.lua`'s `on_venv_activate_callback` stops the
  `basedpyright` client and re-`:edit`s the buffer so the new interpreter is picked up; `lualine.lua`
  reads `require("venv-selector").venv()` to show the active env in the statusline.
- **Git is split by concern, not merged into one plugin**: `telescope.lua` provides `git_commits`/
  `git_branches`/`git_status` pickers (`<leader>gc/gb/gs`) for browsing history; `git.lua`'s
  `gitsigns.nvim` is the separate, narrower job of showing which lines changed *right now* (gutter
  signs, hunk stage/reset, inline blame). Don't collapse these back into one LazyGit-style plugin.
- **gitsigns must load before any buffer is opened, not on the events it watches**: `git.lua` uses
  `event = "VeryLazy"`, deliberately *not* `BufReadPre`/`BufNewFile`. gitsigns attaches to buffers via
  its own autocmd on those same events — lazy-loading the plugin on them races, since registering that
  autocmd mid-event can miss the very buffer that triggered the plugin's own load. `VeryLazy` fires
  once, early, well before any file gets opened, so gitsigns' attach hook is always armed in time.
- **Terminal toggle is vanilla Lua, not a plugin**: the `<leader>t` bottom-split terminal (native
  `:terminal`, buffer reused across toggles) lives directly in `vim-options.lua`, not under
  `lua/plugins/`, because it has no external dependency — don't wrap it in a plugin spec.
- **neo-tree ↔ bufferline offset**: `bufferline.lua` reserves left-side space for the `neo-tree` filetype
  via `options.offsets`; if neo-tree's width (`neo-tree.lua`, currently 35) changes, check that offset.
- **neo-tree's `close_if_last_window` stays `false`**: with `true`, neo-tree quits *Neovim itself* (not
  just the tree) whenever it decides it's the last "real" window — which a plain `:bdelete` on the
  visible buffer can trigger by leaving the window looking buffer-less. `bufferline.lua`'s `<leader>q`
  already avoids the trigger (switches to the previous/a fresh buffer *before* deleting the old one,
  never leaving the window buffer-less), so `close_if_last_window = false` is redundant defense, not the
  only fix — don't remove either half without re-testing the other.
- **`oil.nvim` was tried and removed**: it was added briefly as a directory-as-buffer alternative to
  neo-tree, but conflicted with it in practice (UI overlap when opening files) and was pulled back out.
  Don't reintroduce it without being asked.
- **which-key groups** (`editor.lua`) must be kept in sync with leader prefixes used elsewhere — new
  `<leader>X...` mappings in another file should get a matching group label added to the `wk.add(...)` call
  only if they introduce a genuinely new multi-key prefix (a single leaf keymap like `<leader>e` doesn't
  need one).
- **`.env` loading is autoload-only**: `dotenv.lua` loads `.env` from the project root on startup
  (`enable_on_load = true`); there's no custom picker or viewer — use the plugin's own `:Dotenv <file>`
  command to load a different file manually.
- **Diagnostics default to `virtual_lines`, not `virtual_text`**: `lsp.lua`'s `vim.diagnostic.config()`
  shows the current line's diagnostic as its own line underneath instead of truncated end-of-line text;
  `<leader>D` toggles back to classic `virtual_text` at runtime (global, not per-buffer).

**Keybindings are documented, not discoverable from code alone.** `KEYBINDINGS.md` is a hand-maintained
reference table mirroring every `vim.keymap.set` across `lua/plugins/*.lua`. When adding, changing, or
removing a keymap in any plugin file, update the corresponding row in `KEYBINDINGS.md` in the same
change — it is the canonical source users read, and it will drift silently otherwise. Leader is `\`
(backslash), set in `vim-options.lua`.

**Design constraints baked into `vim-options.lua`** worth preserving when editing it: 4-space Python-style
indentation is the global default (not per-filetype), `colorcolumn=120`, relative+absolute line numbers
together, system clipboard sync (`unnamedplus`), and persistent undo — these read as intentional, not
defaults left untouched.
