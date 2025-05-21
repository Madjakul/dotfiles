return {
    "gruvbox-community/gruvbox",
    -- load at startup so `colorscheme` actually runs
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_transparent_bg = 0
        vim.g.gruvbox_improved_strings = 0
        vim.g.gruvbox_improved_warnings = 1
        -- choose soft/hard contrast for the dark theme
        vim.g.gruvbox_contrast_dark = "soft"
        -- if you want the light variant, use:
        -- vim.g.gruvbox_contrast_light = "soft"
        vim.o.background = "dark" -- or "light"
        vim.cmd("colorscheme gruvbox")
    end,
}
