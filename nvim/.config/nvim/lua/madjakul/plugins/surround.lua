-- lua/madjakul/plugins/surround.lua
-- Surround text objects with brackets, quotes, tags

return {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = true,
}
