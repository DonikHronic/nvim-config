return {
    -- ── Core DAP client ───────────────────────────────────────────────────────
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python", -- Python-specific dap setup
        },
        config = function()
            local dap   = require("dap")
            local dappy = require("dap-python")

            -- ── nvim-dap-python: find debugpy installed by Mason ──────────────
            -- Mason installs debugpy into a virtualenv at this path
            local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
            local debugpy_path   = mason_packages .. "/debugpy/venv/bin/python"
            dappy.setup(debugpy_path)

            -- ── Keymaps (F-keys for quick continue/step) ───────────────────────
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { desc = "Debug: " .. desc })
            end

            map("<F5>",       dap.continue,           "Start / Continue")
            map("<F10>",      dap.step_over,           "Step Over")
            map("<F11>",      dap.step_into,           "Step Into")
            map("<F12>",      dap.step_out,            "Step Out")
            map("<leader>b",  dap.toggle_breakpoint,   "Toggle Breakpoint")
            map("<leader>B",  function()
                dap.set_breakpoint(vim.fn.input("Condition: "))
            end,                                       "Conditional Breakpoint")
            map("<leader>dr", dap.repl.open,           "Open REPL")
            map("<leader>dl", dap.run_last,            "Re-run Last Session")
        end,
    },
}
