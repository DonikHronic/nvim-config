return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            -- false, not true: with true, deleting your last real buffer (e.g. plain
            -- :bdelete on the visible buffer) can leave the content window looking
            -- "empty" to neo-tree, which then decides it's alone and quits Neovim
            -- entirely — not just the tree. bufferline.lua's <leader>q already avoids
            -- the trigger (switches away before deleting), but this is a second layer
            -- against the same footgun via any other path (manual :bdelete, etc.).
            close_if_last_window = false,
            window = {
                width    = 35,
                position = "left",
                mappings = {
                    ["<space>"] = "none", -- don't steal leader from other keymaps
                },
            },
            filesystem = {
                filtered_items = {
                    visible          = false,
                    hide_dotfiles    = false, -- show .env, .gitignore, etc.
                    hide_gitignored  = true,
                    hide_by_name     = { "__pycache__", ".mypy_cache", ".ruff_cache" },
                    never_show       = { ".DS_Store", "thumbs.db" },
                },
                follow_current_file = {
                    enabled = true, -- auto-reveal the current file in the tree
                },
                use_libuv_file_watcher = true, -- auto-refresh on external changes
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        added     = "✚",
                        modified  = "",
                        deleted   = "✖",
                        renamed   = "󰁕",
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = "",
                    },
                },
            },
        })

        -- <leader>1 toggles the file tree
        vim.keymap.set("n", "<leader>1", ":Neotree filesystem reveal left toggle<CR>",
            { desc = "Toggle File Tree", silent = true })
        -- <leader>e reveals the current file in the tree
        vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal<CR>",
            { desc = "Reveal File in Tree", silent = true })
    end,
}
