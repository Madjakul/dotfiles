return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
        require("gruvbox").setup({
            contrast = "", -- can be "hard", "soft" or empty string
        })
        vim.cmd("colorscheme gruvbox")
    end,
}
