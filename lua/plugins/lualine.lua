return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "linux-cultist/venv-selector.nvim", -- for venv component
    },
    config = function()
        require("lualine").setup({
            options = {
                theme            = "gruvbox",
                globalstatus     = true, -- single statusline across all splits
                component_separators = { left = "", right = "" },
                section_separators  = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    { "filename", path = 1 }, -- relative path, not just filename
                },
                lualine_x = {
                    -- Active Python virtual environment
                    {
                        function()
                            local venv = require("venv-selector").venv()
                            if venv then
                                -- Extract just the env name from the full path
                                local name = venv:match("([^/]+)/bin/python")
                                return "  " .. (name or venv)
                            end
                            return ""
                        end,
                        cond = function()
                            return vim.bo.filetype == "python"
                        end,
                        color = { fg = "#98c379" },
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
