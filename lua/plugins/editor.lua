return {
    -- ── mini.nvim: auto-pairs, comments, surround, indent-scope in one dependency-
    -- free library instead of four separate small plugins from four authors ─────
    {
        "echasnovski/mini.nvim",
        version = false,
        event   = { "BufReadPre", "BufNewFile" },
        config  = function()
            -- Auto-pairs: closes brackets/quotes automatically
            require("mini.pairs").setup()

            -- Comments: gcc toggles line comment (normal + visual, via 'commentstring')
            require("mini.comment").setup()

            -- Surround: remapped to the classic vim-surround mnemonics this config already
            -- documents in KEYBINDINGS.md — ysiw" / cs"' / ds" behave exactly as before.
            require("mini.surround").setup({
                mappings = {
                    add     = "ys", -- ysiw"  → surround word with "
                    delete  = "ds", -- ds"    → delete surrounding "
                    replace = "cs", -- cs"'   → change surrounding " to '
                },
            })

            -- Indent guide: animated highlight of the current scope (not static guides on
            -- every indent level — a deliberately different, lighter visual than before)
            local miniindentscope = require("mini.indentscope")
            miniindentscope.setup({
                draw = { animation = miniindentscope.gen_animation.none() },
                symbol = "│",
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "dashboard", "neo-tree", "lazy", "mason" },
                callback = function() vim.b.miniindentscope_disable = true end,
            })
        end,
    },

    -- ── Which-key: shows available keybindings popup ──────────────────────────
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                delay = 300,                          -- ms before the popup shows (matches timeoutlen)
                triggers = {
                    { "<leader>", mode = { "n", "v" } }, -- ONLY normal + visual, NOT insert
                }
            })

            -- Register group labels so which-key shows readable categories
            wk.add({
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>h", group = "Git Hunk" },
                { "<leader>l", group = "LSP" },
                { "<leader>d", group = "Debug" },
                { "<leader>v", group = "Venv" },
            })
        end,
    },
}
