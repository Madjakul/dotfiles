-- lua/madjakul/plugins/colorscheme.lua
-- Gruvbox Material: the "material" foreground gives the pale, less aggressive colors.
-- No need to manually map palettes — sainnhe/gruvbox-material handles everything natively.

return {
    "sainnhe/gruvbox-material",
    priority = 1000,
    lazy = false,
    config = function()
        -- "material" foreground = pale/soft colors (what you want)
        -- "mix" = halfway between original gruvbox and material
        -- "original" = classic gruvbox colors
        vim.g.gruvbox_material_foreground = "material"

        -- Background contrast: "soft", "medium" (default), "hard"
        vim.g.gruvbox_material_background = "medium"

        -- Enable italic comments (requires a font with italic support)
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_enable_bold = 1

        -- Better diagnostic text readability
        vim.g.gruvbox_material_diagnostic_text_highlight = 1

        -- Statusline uses the "mix" palette variant for slight contrast
        vim.g.gruvbox_material_statusline_style = "mix"

        -- Performance: cache highlight groups (faster reloads)
        vim.g.gruvbox_material_better_performance = 1

        -- Let terminal colors follow the theme
        vim.g.gruvbox_material_disable_terminal_colors = 0

        -- Float and popup styling
        vim.g.gruvbox_material_float_style = "dim"

        vim.cmd("colorscheme gruvbox-material")
    end,
}
