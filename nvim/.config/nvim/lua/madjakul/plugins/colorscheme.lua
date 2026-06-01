-- lua/madjakul/plugins/colorscheme.lua
-- Gruvbox Material with "material" (pale) foreground.
-- Treesitter + Pyright handle all semantic highlighting natively.

return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	lazy = false,
	config = function()
		vim.g.gruvbox_material_foreground = "material"
		vim.g.gruvbox_material_background = "soft"
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_enable_bold = 1
		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
		vim.g.gruvbox_material_diagnostic_line_highlight = 1
		vim.g.gruvbox_material_statusline_style = "mix"
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_disable_terminal_colors = 0
		vim.g.gruvbox_material_float_style = "dim"

		vim.cmd("colorscheme gruvbox-material")
	end,
}
