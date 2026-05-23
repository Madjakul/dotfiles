-- lua/madjakul/plugins/vim-maximizer.lua
-- Toggle maximize/minimize a split

return {
    "szw/vim-maximizer",
    keys = {
        { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
}
