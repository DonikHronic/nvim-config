return {
    "akinsho/bufferline.nvim",
    version      = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("bufferline").setup({
            options = {
                mode              = "buffers",
                separator_style   = "slant",
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                show_close_icon   = false,
                color_icons       = true,
                -- Integrate with neo-tree: keep the left panel offset
                offsets = {
                    {
                        filetype   = "neo-tree",
                        text       = "File Explorer",
                        highlight  = "Directory",
                        text_align = "left",
                    },
                },
                diagnostics = "nvim_lsp", -- show error/warn count on tab
                diagnostics_indicator = function(_, _, diagnostics_dict)
                    local s = " "
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or "")
                        s = s .. n .. sym
                    end
                    return s
                end,
            },
        })

        -- Tab navigation between buffers
        vim.keymap.set("n", "<Tab>",   "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Next Tab" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Prev Tab" })

        -- Close buffer without closing the window. Switches away first (previous buffer,
        -- or a fresh empty one if this is the last listed buffer) instead of bdelete-ing
        -- the visible buffer in place — deleting it in place leaves the window looking
        -- "buffer-less" for a moment, which neo-tree's last-window watcher can pick up on.
        vim.keymap.set("n", "<leader>q", function()
            local buf = vim.api.nvim_get_current_buf()
            local listed = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
            if #listed <= 1 then
                vim.cmd("enew")
            else
                vim.cmd("bprevious")
            end
            vim.cmd("bdelete " .. buf)
        end, { desc = "Buffer: Close" })

        -- Jump to buffer by position with Alt+1..9
        -- Note: <leader>1 is reserved for neo-tree (file explorer)
        for i = 1, 9 do
            vim.keymap.set("n", "<A-" .. i .. ">",
                "<cmd>BufferLineGoToBuffer " .. i .. "<cr>",
                { desc = "Buffer: Go to Tab " .. i })
        end
    end,
}
