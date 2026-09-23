return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- load before everything else
    config = function()
        require("gruvbox").setup({
            contrast   = "hard",    -- "hard" | "medium" | "soft"
            transparent_mode = false,
        })
        vim.o.background = "dark"
        vim.cmd.colorscheme("gruvbox")
    end,
}
