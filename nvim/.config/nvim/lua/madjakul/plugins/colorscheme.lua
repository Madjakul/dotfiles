-- return {
--     "sainnhe/gruvbox-material",
--     priority = 1000,
--     lazy = false,
--     config = function()
--         vim.g.gruvbox_material_background = "medium"
--         vim.g.gruvbox_material_foreground = "mix"
--         vim.g.gruvbox_material_enable_bold = 1
--         vim.g.gruvbox_material_enable_italic = 1
--         vim.g.gruvbox_material_diagnostic_text_highlight = 1
--         vim.g.gruvbox_material_disable_terminal_colors = 1
--         vim.g.gruvbox_material_statusline_style = "mix"
--         vim.g.gruvbox_material_better_performance = 0
--
--         vim.cmd("colorscheme gruvbox-material")
--     end,
-- }

return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
        local sainnhe_material_dark_palette = {
            bg_dim = "#1b1b1b", -- Not directly mapped to a common ellisonleao/gruvbox key, but could be used for specific 'overrides' if needed
            bg0 = "#282828",
            bg1 = "#32302f",
            bg2 = "#32302f",
            bg3 = "#45403d",
            bg4 = "#45403d",

            fg0 = "#fbf1c7",
            fg1 = "#ebdbb2",
            fg2_approx = "#d5c4a1",
            fg3_approx = "#bdae93",
            fg4_approx = "#a89984",

            red = "#ea6962",
            orange = "#e78a4e",
            yellow = "#d8a657",
            green = "#a9b665",
            aqua = "#89b482",
            blue = "#7daea3",
            purple = "#d3869b",

            sainnhe_grey0 = "#7c6f64",
            sainnhe_grey1 = "#928374", -- Often used for comments in gruvbox
            sainnhe_grey2 = "#a89984",

            -- Backgrounds for visual selections
            sainnhe_bg_visual_red = "#4c3432",
            sainnhe_bg_visual_green = "#3b4439",
            sainnhe_bg_visual_blue = "#374141",
            sainnhe_bg_visual_yellow = "#4f422e",

            -- Backgrounds for diffs
            sainnhe_bg_diff_red = "#402120",
            sainnhe_bg_diff_green = "#34381b",
            sainnhe_bg_diff_blue = "#0e363e",

            bg_current_word = "3c3836",

            -- Status line
            bg_statusline1 = "#32302f",
            bg_statusline2 = "#3a3735",
            bg_statusline3 = "#504945",
        }

        require("gruvbox").setup({
            terminal_colors = false, -- User preference
            undercurl = true,
            underline = false, -- User preference
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = true,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            inverse = true,
            contrast = "", -- User preference, will use ellisonleao's soft palette as a base before overrides
            palette_overrides = {
                -- Backgrounds
                bg0 = sainnhe_material_dark_palette.bg0,
                bg1 = sainnhe_material_dark_palette.bg1,
                bg2 = sainnhe_material_dark_palette.bg2,
                bg3 = sainnhe_material_dark_palette.bg3,
                bg4 = sainnhe_material_dark_palette.bg4,

                -- Foregrounds
                fg0 = sainnhe_material_dark_palette.fg0,
                fg1 = sainnhe_material_dark_palette.fg1,
                fg2 = sainnhe_material_dark_palette.fg2_approx,
                fg3 = sainnhe_material_dark_palette.fg3_approx,
                fg4 = sainnhe_material_dark_palette.fg4_approx,

                -- Base Colors (used for both neutral and bright by ellisonleao if not specified separately)
                red = sainnhe_material_dark_palette.red,
                orange = sainnhe_material_dark_palette.orange,
                yellow = sainnhe_material_dark_palette.yellow,
                green = sainnhe_material_dark_palette.green,
                aqua = sainnhe_material_dark_palette.aqua,
                blue = sainnhe_material_dark_palette.blue,
                purple = sainnhe_material_dark_palette.purple,

                grey = sainnhe_material_dark_palette.sainnhe_grey1, -- Standard for comments
                gray = sainnhe_material_dark_palette.sainnhe_grey1, -- Alias

                -- Neutral versions (ellisonleao/gruvbox.nvim specific keys)
                neutral_red = sainnhe_material_dark_palette.red,
                neutral_orange = sainnhe_material_dark_palette.orange,
                neutral_yellow = sainnhe_material_dark_palette.yellow,
                neutral_green = sainnhe_material_dark_palette.green,
                neutral_aqua = sainnhe_material_dark_palette.aqua,
                neutral_blue = sainnhe_material_dark_palette.blue,
                neutral_purple = sainnhe_material_dark_palette.purple,

                -- Bright versions (ellisonleao/gruvbox.nvim specific keys)
                -- Sainnhe's material colors are generally vibrant, so they map well to "bright"
                bright_red = sainnhe_material_dark_palette.red,
                bright_orange = sainnhe_material_dark_palette.orange,
                bright_yellow = sainnhe_material_dark_palette.yellow,
                bright_green = sainnhe_material_dark_palette.green,
                bright_aqua = sainnhe_material_dark_palette.aqua,
                bright_blue = sainnhe_material_dark_palette.blue,
                bright_purple = sainnhe_material_dark_palette.purple,

                -- Specific UI element backgrounds
                bg_visual_red = sainnhe_material_dark_palette.sainnhe_bg_visual_red,
                bg_visual_green = sainnhe_material_dark_palette.sainnhe_bg_visual_green,
                bg_visual_blue = sainnhe_material_dark_palette.sainnhe_bg_visual_blue,
                bg_visual_yellow = sainnhe_material_dark_palette.sainnhe_bg_visual_yellow,
                --
                bg_diff_red = sainnhe_material_dark_palette.sainnhe_bg_diff_red,
                bg_diff_green = sainnhe_material_dark_palette.sainnhe_bg_diff_green,
                bg_diff_blue = sainnhe_material_dark_palette.sainnhe_bg_diff_blue,

                -- Statusline backgrounds (ellisonleao/gruvbox.nvim often derives these from bg0-bg4)
                -- Explicitly setting them based on sainnhe's bg shades:
                bg_statusline1 = sainnhe_material_dark_palette.bg_statusline1, -- Or bg2 for more contrast
                bg_statusline2 = sainnhe_material_dark_palette.bg_statusline2, -- Or bg3
                bg_statusline3 = sainnhe_material_dark_palette.bg_statusline3, -- Or bg_dim for very low contrast

                none = "NONE",
            },
            overrides = {
                ["@string"] = { fg = "#b8bb26" },
                ["@string.documentation"] = { fg = "#b8bb26" },
                ["@constructor.python"] = { fg = sainnhe_material_dark_palette.yellow },
                ["@punctuation.bracket"] = { fg = sainnhe_material_dark_palette.fg1 },
                ["@punctuation.delimiter"] = { fg = sainnhe_material_dark_palette.fg1 },
            },
            dim_inactive = false,
            transparent_mode = false,
        })
        vim.cmd("colorscheme gruvbox")
    end,
}
