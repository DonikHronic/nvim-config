return {
    {
        "nvim-telescope/telescope.nvim",
        tag          = "v0.2.2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local builtin   = require("telescope.builtin")
            local themes    = require("telescope.themes")

            telescope.setup({
                defaults = {
                    -- Layout
                    layout_strategy = "horizontal",
                    layout_config   = { preview_width = 0.55 },
                    -- Use ripgrep: respects .gitignore, stays in cwd, fast on large repos
                    vimgrep_arguments = {
                        "rg", "--color=never", "--no-heading", "--with-filename",
                        "--line-number", "--column", "--smart-case",
                        "--hidden",        -- include dotfiles (.env etc.)
                        "--glob=!.git/",   -- never cross into .git
                    },
                    file_ignore_patterns = {
                        "%.git/", "__pycache__/", "%.pyc", "node_modules/",
                        "%.venv/", "venv/", "%.mypy_cache/", "%.ruff_cache/",
                        "%.pytest_cache/", "dist/", "build/", "%.egg%-info/",
                    },
                    path_display     = { "truncate" },
                    sorting_strategy = "ascending",
                },

                extensions = {
                    fzf = {
                        fuzzy                   = true,
                        override_generic_sorter  = true,
                        override_file_sorter     = true,
                        case_mode               = "smart_case",
                    },
                    ["ui-select"] = {
                        themes.get_dropdown({}),
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")

            -- ── Keymaps ───────────────────────────────────────────────────────

            -- File / text search
            vim.keymap.set("n", "<leader>ff", builtin.find_files,                 { desc = "Find: Files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep,                  { desc = "Find: Live Grep" })
            vim.keymap.set("n", "<leader>fw", builtin.grep_string,                { desc = "Find: Word Under Cursor" })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles,                   { desc = "Find: Recent Files" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers,                    { desc = "Find: Open Buffers" })

            -- Neovim meta
            vim.keymap.set("n", "<leader>fh", builtin.help_tags,                  { desc = "Find: Help Tags" })
            vim.keymap.set("n", "<leader>fk", builtin.keymaps,                    { desc = "Find: Keymaps" })
            vim.keymap.set("n", "<leader>fc", builtin.commands,                   { desc = "Find: Commands" })

            -- Git
            vim.keymap.set("n", "<leader>gc", builtin.git_commits,                { desc = "Git: Commits" })
            vim.keymap.set("n", "<leader>gb", builtin.git_branches,               { desc = "Git: Branches" })
            vim.keymap.set("n", "<leader>gs", builtin.git_status,                 { desc = "Git: Status" })
        end,
    },

    -- ── fzf native sorter (much faster on large repos) ───────────────────────
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },

    -- ── telescope-ui-select: uses telescope for vim.ui.select ────────────────
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
}
