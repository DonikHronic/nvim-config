-- ── Bootstrap lazy.nvim ───────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit...",   "" },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- ── Setup ─────────────────────────────────────────────────────────────────────
require("lazy").setup("plugins", {
    checker = {
        enabled   = true,  -- check for updates in background
        notify    = false, -- don't pop a notification, check :Lazy manually
        frequency = 86400, -- check once per day, not every startup
    },
    change_detection = {
        enabled = true,
        notify  = false,   -- don't banner when config files change
    },
    install = {
        missing = true,    -- silently install missing plugins on startup
    },
})
