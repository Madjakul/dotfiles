-- lua/madjakul/plugins/treesitter.lua
-- nvim-treesitter 1.0 API: require("nvim-treesitter.configs") was REMOVED.
-- Use require("nvim-treesitter").setup() instead.
-- autotag is now a standalone plugin with its own setup.

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		-- nvim-ts-autotag now requires its own setup call (not via treesitter)
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup({
					opts = {
						enable_close = true,
						enable_rename = true,
						enable_close_on_slash = false,
					},
				})
			end,
		},
	},
	config = function()
		-- NEW API: require("nvim-treesitter"), NOT the old "nvim-treesitter.configs"
		require("nvim-treesitter").setup({
			ensure_installed = {
				-- Core languages
				"python",
				"lua",
				"bash",
				"c",
				"cpp",
				"cuda",
				"rust",

				-- Config / data formats
				"json",
				"yaml",
				"toml",
				"ini",
				"xml",

				-- Markup
				"markdown",
				"markdown_inline",
				"bibtex",
				"rst",
				"latex",

				-- DevOps
				"dockerfile",
				"cmake",
				"make",
				"ssh_config",

				-- Git
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",

				-- Editor / meta
				"vim",
				"vimdoc",
				"tmux",
				"regex",
				"comment",
			},

			auto_install = true,

			highlight = {
				enable = true,
				-- Disable for large files (prevents freeze on accidental checkpoint opens)
				disable = function(_, buf)
					local max_filesize = 512 * 1024 -- 512 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},

			indent = { enable = true },
		})
	end,
}
