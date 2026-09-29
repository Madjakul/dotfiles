-- lua/madjakul/plugins/web-devicons.lua
-- File icons. Upstream maps yml/yaml to U+E8EB, which only exists in very
-- recent Nerd Fonts; pin them to nf-seti-yml (U+E6A8) so they render with v3.0+.

return {
    "nvim-tree/nvim-web-devicons",
    opts = {
        override_by_extension = {
            yml = { icon = "\u{e6a8}", color = "#D70000", cterm_color = "160", name = "Yml" },
            yaml = { icon = "\u{e6a8}", color = "#D70000", cterm_color = "160", name = "Yaml" },
        },
    },
}
