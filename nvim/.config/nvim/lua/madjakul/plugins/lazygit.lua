-- lua/madjakul/plugins/lazygit.lua
-- Git TUI inside Neovim

return {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
}
