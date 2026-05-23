-- lua/madjakul/plugins/bufferline.lua
-- Tab bar at the top of the editor

return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            separator_style = "slant",
        },
    },
}
