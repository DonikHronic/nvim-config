return {
    "ellisonleao/dotenv.nvim",
    -- Load early so env vars are available to LSP, debugger, and terminal
    priority = 900,
    event    = "VeryLazy",
    config   = function()
        require("dotenv").setup({
            -- Automatically load the .env file found in the project root (cwd)
            -- when Neovim starts or when you change directory
            enable_on_load = true,

            -- File to look for. Tries each in order, loads the first one found.
            -- You can override at any time with :Dotenv .env.local
            dotenv_filename = ".env",

            -- Warn (don't error) if no .env file is found in the project
            -- This is useful so opening non-Python projects doesn't spam messages
            show_error = false,
        })
    end,
}
