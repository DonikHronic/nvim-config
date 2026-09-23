return {
    -- ── Mason: installs LSP servers, linters, formatters ──────────────────────
    {
        "williamboman/mason.nvim",
        priority = 100,
        config = function()
            require("mason").setup({
                ui = { border = "rounded" },
            })
        end,
    },

    -- ── Mason-lspconfig: bridges Mason ↔ Neovim's built-in LSP ───────────────
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "basedpyright",
                    "ruff",
                    "lua_ls",
                },
                automatic_installation = true,
            })
        end,
    },

    -- ── Mason tool installer: debuggers / formatters (non-LSP) ────────────────
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = { "debugpy", "ruff" },
                auto_update  = false,
                run_on_start = true,
            })
        end,
    },

    -- ── LSP configuration (Neovim 0.11+ native API) ───────────────────────────
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- ── basedpyright ──────────────────────────────────────────────────
            vim.lsp.config("basedpyright", {
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        typeCheckingMode     = "standard",
                        autoImportCompletion = true,
                        analysis = {
                            autoSearchPaths        = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode         = "workspace",
                        },
                    },
                },
            })

            -- ── ruff (linting only) ────────────────────────────────────────────
            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = function(client, _)
                    -- Disable hover: basedpyright owns that
                    client.server_capabilities.hoverProvider = false
                end,
            })

            -- ── lua_ls (for editing this config) ──────────────────────────────
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime  = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library        = vim.api.nvim_get_runtime_file("", true),
                        },
                        diagnostics = { globals = { "vim" } },
                        telemetry   = { enable = false },
                    },
                },
            })

            -- Enable all three servers
            vim.lsp.enable({ "basedpyright", "ruff", "lua_ls" })

            -- ── Diagnostic display ────────────────────────────────────────────
            -- Long ruff/basedpyright messages read better as their own line under the
            -- code than truncated at end-of-line, so show virtual_lines on the current
            -- line only (gutter signs + underline still mark every diagnostic location).
            vim.diagnostic.config({
                virtual_text     = false,
                virtual_lines    = { current_line = true },
                signs            = true,
                underline        = true,
                update_in_insert = false,
                severity_sort    = true,
                float = {
                    border = "rounded",
                    source = true,
                },
            })

            -- <leader>D  →  toggle between virtual_lines (default) and classic virtual_text
            local diagnostics_mode = "virtual_lines"
            vim.keymap.set("n", "<leader>D", function()
                if diagnostics_mode == "virtual_lines" then
                    vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
                    diagnostics_mode = "virtual_text"
                else
                    vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
                    diagnostics_mode = "virtual_lines"
                end
            end, { desc = "Diagnostics: Toggle Virtual Text / Lines" })

            -- ── Keymaps (only active when LSP attaches) ───────────────────────
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
                callback = function(event)
                    local buf = event.buf
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
                    end

                    -- Native completion (Neovim 0.11+): auto-popup as you type, no plugin needed
                    vim.lsp.completion.enable(true, event.data.client_id, buf, { autotrigger = true })

                    -- Navigation
                    map("gd",         vim.lsp.buf.definition,                              "Go to Definition")
                    map("gD",         vim.lsp.buf.declaration,                             "Go to Declaration")
                    map("gi",         vim.lsp.buf.implementation,                          "Go to Implementation")
                    map("gr",         require("telescope.builtin").lsp_references,         "Find References")
                    map("gt",         vim.lsp.buf.type_definition,                         "Go to Type Definition")

                    -- Docs & Signature
                    map("K",          vim.lsp.buf.hover,                                   "Hover Docs")
                    map("<leader>k",  vim.lsp.buf.signature_help,                          "Signature Help")

                    -- Code actions
                    map("<leader>rn", vim.lsp.buf.rename,                                  "Rename Symbol")
                    map("<leader>la", vim.lsp.buf.code_action,                             "Code Action")
                    vim.keymap.set("v", "<leader>la", vim.lsp.buf.code_action,
                        { buffer = buf, desc = "LSP: Code Action (range)" })

                    -- Symbols
                    map("<leader>ls", require("telescope.builtin").lsp_document_symbols,   "Document Symbols")
                    map("<leader>lS", require("telescope.builtin").lsp_workspace_symbols,  "Workspace Symbols")

                    -- Diagnostics navigation
                    map("[d",         vim.diagnostic.goto_prev,                            "Prev Diagnostic")
                    map("]d",         vim.diagnostic.goto_next,                            "Next Diagnostic")
                    map("<leader>d",  vim.diagnostic.open_float,                           "Show Diagnostic")
                end,
            })
        end,
    },
}
