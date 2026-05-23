-- lua/madjakul/plugins/avante.lua
-- AI chat panel in Neovim: Claude as primary provider for a VSCode-like experience.
-- Set ANTHROPIC_API_KEY in your environment (add to private_aliases or .bashrc on servers).
-- Usage: <leader>aa to toggle chat, <leader>ae to edit selection with AI.

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	opts = {
		-- Use Claude as the primary AI provider
		provider = "claude",
		-- NEW: all provider configs go under the "providers" table
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-20250514",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_tokens = 8192,
				},
			},
			-- Copilot as a fallback (switch with :Avante provider copilot)
			copilot = {
				model = "gpt-4o",
				extra_request_body = {
					max_tokens = 8192,
				},
			},
		},
		-- Chat behavior
		behaviour = {
			auto_suggestions = false, -- disable auto-suggestions to avoid lag over SSHFS
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			support_paste_from_clipboard = true,
		},
		-- File selector uses Telescope
		file_selector = {
			provider = "telescope",
		},
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua", -- still needed for copilot fallback provider
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = { insert_mode = true },
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
