-- ── Leader ────────────────────────────────────────────────────────────────────
vim.g.mapleader      = "\\"
vim.g.maplocalleader = "\\"

-- ── Editor behaviour ──────────────────────────────────────────────────────────
vim.cmd("set mouse=a")        -- mouse support in all modes
vim.cmd("set number")         -- absolute line numbers
vim.cmd("set relativenumber") -- relative numbers for fast jumps (j/k)
vim.cmd("set noswapfile")
vim.cmd("set encoding=utf-8")
vim.cmd("set colorcolumn=120") -- 120-column right margin

-- ── Indentation (Python-first: 4 spaces) ──────────────────────────────────────
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set autoindent")
vim.cmd("set smartindent")

-- ── Search ────────────────────────────────────────────────────────────────────
vim.opt.ignorecase    = true -- case-insensitive search …
vim.opt.smartcase     = true -- … unless you type an uppercase letter
vim.opt.hlsearch      = true -- highlight matches
vim.opt.incsearch     = true -- live preview while typing

-- ── Splits ───────────────────────────────────────────────────────────────────
vim.opt.splitright    = true -- vertical split opens on the right
vim.opt.splitbelow    = true -- horizontal split opens below

-- ── Appearance ────────────────────────────────────────────────────────────────
vim.opt.termguicolors = true  -- 24-bit colour (required by most themes)
vim.opt.signcolumn    = "yes" -- always show the gutter (prevents layout shift on diagnostics)
vim.opt.cursorline    = true  -- highlight the current line
vim.opt.scrolloff     = 8     -- keep 8 lines visible above/below cursor
vim.opt.wrap          = false -- no line wrapping

-- ── Performance ───────────────────────────────────────────────────────────────
vim.opt.updatetime    = 250 -- faster CursorHold events (used by LSP highlights)
vim.opt.timeoutlen    = 300 -- which-key popup delay

-- ── Clipboard ─────────────────────────────────────────────────────────────────
vim.opt.clipboard     = "unnamedplus" -- sync with system clipboard (Ctrl+C / Ctrl+V in other apps)

-- ── Undo history ──────────────────────────────────────────────────────────────
vim.opt.undofile      = true -- persist undo history across sessions
vim.opt.undolevels    = 10000

-- ── Misc ──────────────────────────────────────────────────────────────────────
vim.opt.completeopt   = { "menu", "menuone", "noselect" } -- needed for the native LSP completion popup

-- ── Terminal ──────────────────────────────────────────────────────────────────
-- <leader>t toggles a persistent bottom-split terminal using native :terminal — no plugin.
-- The same buffer is reused across toggles so shell state (cwd, running jobs) survives.
local term_state = { buf = nil, win = nil }
local function toggle_terminal()
    if term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
        vim.api.nvim_win_close(term_state.win, false)
        term_state.win = nil
        return
    end
    if term_state.buf and vim.api.nvim_buf_is_valid(term_state.buf) then
        vim.cmd("botright split")
        vim.api.nvim_win_set_buf(0, term_state.buf)
    else
        vim.cmd("botright split | resize 15 | terminal")
        term_state.buf = vim.api.nvim_get_current_buf()
    end
    term_state.win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
end
vim.keymap.set("n", "<leader>t", toggle_terminal, { desc = "Terminal: Toggle" })

-- Exit terminal mode back to Normal mode with Esc, like everywhere else in Neovim
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal: Exit to Normal Mode" })
