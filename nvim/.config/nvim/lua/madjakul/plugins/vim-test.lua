-- lua/madjakul/plugins/vim-test.lua
-- Run tests from Neovim via tmux (vimux)

return {
    "vim-test/vim-test",
    dependencies = { "preservim/vimux" },
    config = function()
        vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", { desc = "Test nearest" })
        vim.keymap.set("n", "<leader>T", ":TestFile<CR>", { desc = "Test file" })
        vim.cmd("let test#strategy = 'vimux'")
    end,
}
