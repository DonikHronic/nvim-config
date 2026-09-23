# Neovim Python IDE — Quick Reference

> Leader key = `\`

---
## Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find all references |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `<leader>k` | Signature help |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>d` | Show diagnostic popup |
| `<leader>D` | Toggle diagnostic display (virtual lines ↔ virtual text) |

---

## Find (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (project search) |
| `<leader>fw` | Search word under cursor |
| `<leader>fr` | Recent files |
| `<leader>fb` | Open buffers |
| `<leader>fk` | Browse keymaps |
| `<leader>fc` | Browse commands |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |

---

## Code Actions

| Key | Action |
|-----|--------|
| `<leader>rn` | Rename symbol |
| `<leader>la` | Code action / quick fix |
| `gcc` | Toggle line comment |

---

## Treesitter Selection

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Start / expand selection |
| `Ctrl+S` | Expand to scope |
| `Backspace` | Shrink selection |

---

## Surround (mini.surround)

| Key | Action | Example |
|-----|--------|---------|
| `ysiw"` | Surround word with `"` | `word` → `"word"` |
| `cs"'` | Change `"` to `'` | `"word"` → `'word'` |
| `ds"` | Delete surrounding `"` | `"word"` → `word` |

---

## Debugging (nvim-dap)

| Key | Action |
|-----|--------|
| `<F5>` | Start / Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Re-run last session |

---

## Git (Telescope)

| Key | Action |
|-----|--------|
| `<leader>gc` | Browse commits |
| `<leader>gb` | Browse branches |
| `<leader>gs` | Git status picker |

---

## Git Hunk (gitsigns)

Gutter shows `▎` for added/changed lines while you edit — separate from the commit/branch/status
browsing above, this is "which lines changed right now".

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>tb` | Toggle inline blame |

---

## File Tree (Neo-tree)

| Key | Action |
|-----|--------|
| `<leader>1` | Toggle file tree |
| `<leader>e` | Reveal current file in tree |

---

## Terminal

| Key | Action |
|-----|--------|
| `<leader>t` | Toggle bottom-split terminal (native `:terminal`) |
| `<Esc>` | Exit terminal mode back to Normal (while in the terminal buffer) |

---

## Buffers / Tabs

| Key | Action |
|-----|--------|
| `<Tab>` | Next tab |
| `<S-Tab>` | Prev tab |
| `<A-1..9>` | Jump to tab N |
| `<leader>q` | Close buffer |

---

## Python Venv

| Key | Action |
|-----|--------|
| `<leader>vs` | Select virtual environment |
| `<leader>vc` | Show current environment |

---

## Environment Variables (.env)

`.env` in the project root is loaded automatically on startup.
Variable values are injected into Neovim's environment, so the terminal, debugger, and any
subprocess will inherit them. To load a different file manually, run `:Dotenv .env.local`.

---

## Lazy (Plugin Manager)

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Lazy U` | Update all plugins |
| `:Lazy sync` | Install + update + clean |

---

## Mason (LSP / Tool Manager)

| Command | Action |
|---------|--------|
| `:Mason` | Open Mason UI |

---

## Tips

- **Which-key**: press `<Space>` and wait 300ms — a popup shows all available keybindings grouped by category.
- **Completion**: LSP suggestions pop up automatically as you type (built-in, no plugin) — `<C-n>`/`<C-p>` to move through matches, `<C-y>` to accept, `<C-e>` to dismiss.
- **Venv indicator**: the active Python environment is shown in the status bar (bottom right) when editing `.py` files.
- **Diagnostics**: long ruff/basedpyright messages show as their own line under the current line by default; `<leader>D` swaps to the classic end-of-line style if you prefer it.
