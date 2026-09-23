return {
    "nvim-treesitter/nvim-treesitter",
    -- Pinned deliberately: upstream rewrote the plugin on `main` with a breaking config API
    -- (no more `nvim-treesitter.configs`). `master` is the legacy branch this config's setup()
    -- call still targets — it gets no new commits, but switching to `main` is a real migration,
    -- not an update. Don't drop this pin.
    branch = "master",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "python", "lua", "luadoc",
                "javascript", "typescript",
                "html", "css", "json", "yaml", "toml",
                "bash", "dockerfile",
                "markdown", "markdown_inline",
                "regex", "vim", "vimdoc",
            },
            sync_install  = false,
            auto_install  = true,
            highlight = {
                enable  = true,
                disable = function(_, buf)
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    return ok and stats and stats.size > 100 * 1024
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable  = true,
                keymaps = {
                    init_selection    = "<C-space>",
                    node_incremental  = "<C-space>",
                    scope_incremental = "<C-s>",
                    node_decremental  = "<bs>",
                },
            },
        })
    end,
}
