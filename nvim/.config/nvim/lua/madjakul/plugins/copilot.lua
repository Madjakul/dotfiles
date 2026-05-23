-- lua/madjakul/plugins/copilot.lua
-- Copilot provides inline ghost-text suggestions (like VSCode).
-- Chat/edit goes through Avante (Claude). copilot-cmp is removed to avoid
-- the deprecated client.is_stopped warning on Neovim 0.12+.
-- Accept suggestion: Alt-Enter | Dismiss: Ctrl-] | Next: Alt-]

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
					-- accept = "<M-CR>", -- Alt+Enter to accept
					accept_word = "<M-w>", -- Alt+w to accept one word
					-- accept_line = "<M-l>", -- Alt+l to accept one line
					next = "<M-]>", -- Alt+] for next suggestion
					prev = "<M-[>", -- Alt+[ for previous
					dismiss = "<C-]>", -- Ctrl+] to dismiss
				},
			},
			panel = { enabled = false },
			filetypes = {
				["."] = false,
			},
		})
	end,
}
