-- lua/madjakul/plugins/copilot.lua
-- Copilot provides inline ghost-text suggestions (like VSCode).
-- Chat/edit goes through Avante (Claude). copilot-cmp is removed to avoid
-- the deprecated client.is_stopped warning on Neovim 0.12+.
-- Accept: Alt-y | Word: Alt-w | Line: Alt-l | Next/Prev: Alt-]/[ | Dismiss: Ctrl-]

return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    -- Alt+y to accept (Alt+Enter conflicts with Avante)
                    accept = "<M-y>",
                    accept_word = "<M-w>",
                    accept_line = "<M-l>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                ["."] = false,
            },
        })
    end,
}
