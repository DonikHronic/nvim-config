-- Inline "which lines changed" gutter + blame — separate concern from the commit/branch/
-- status browsing Telescope already covers, so no overlap with what was removed earlier.
return {
    "lewis6991/gitsigns.nvim",
    -- Not BufReadPre/BufNewFile: gitsigns attaches to buffers via its own autocmd on those
    -- same events, so lazy-loading it *on* them races — it can miss the very file that
    -- triggered its own load. VeryLazy loads it just after startup, before any file is open.
    event = "VeryLazy",
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = "▎" },
            },
            current_line_blame = false, -- off by default, toggle with <leader>tb

            on_attach = function(buf)
                local gs = require("gitsigns")
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = buf, desc = "Git: " .. desc })
                end

                -- Hunk navigation
                map("]h", gs.next_hunk, "Next Hunk")
                map("[h", gs.prev_hunk, "Prev Hunk")

                -- Stage / reset
                map("<leader>hs", gs.stage_hunk, "Stage Hunk")
                map("<leader>hr", gs.reset_hunk, "Reset Hunk")
                map("<leader>hp", gs.preview_hunk, "Preview Hunk")

                -- Toggle inline blame
                map("<leader>tb", gs.toggle_current_line_blame, "Toggle Line Blame")
            end,
        })
    end,
}
