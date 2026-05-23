-- lua/madjakul/plugins/which-key.lua
-- Shows pending keybindings in a popup

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 750
    end,
    opts = {},
}
