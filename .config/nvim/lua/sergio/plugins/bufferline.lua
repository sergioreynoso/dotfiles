return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "buffers", -- Display buffers (or "tabs")
			numbers = "ordinal", -- Show buffer numbers (or "none", "buffer_id")
			separator_style = "slant", -- Styles: "slant", "thick", "thin"
			always_show_bufferline = false, -- Hide if only one buffer
			diagnostics = "nvim_lsp", -- Show LSP diagnostics
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				return "(" .. count .. ")"
			end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	},
}
