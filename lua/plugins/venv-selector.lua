return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = function()
        require("venv-selector").setup({
            settings = {
                search = {
                    -- Try "fd" first (brew install fd), fall back to "fdfind" on Linux
                    fd_binary_names = { "fd", "fdfind" },
                },
                options = {
                    on_venv_activate_callback = function()
                        -- Restart basedpyright so it picks up the new interpreter
                        local clients = vim.lsp.get_clients({ name = "basedpyright" })
                        for _, client in ipairs(clients) do
                            vim.lsp.stop_client(client.id, true)
                        end
                        vim.cmd("edit") -- reload buffer to re-attach LSP
                    end,
                },
            },
        })

        -- <leader>vs  →  open the venv picker
        vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>",
            { desc = "Venv: Select Python Environment" })
        -- <leader>vc  →  show currently active venv
        vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCurrent<cr>",
            { desc = "Venv: Show Current Environment" })
    end,
}
