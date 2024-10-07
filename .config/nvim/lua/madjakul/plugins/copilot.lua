return {
    "github/copilot.vim",
    vim.api.nvim_set_keymap("i", "<M-CR>", 'copilot#Accept("<CR>")', { expr = true, noremap = true, silent = true }),
}
