return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		preset = "modern",
		triggers = {
			{ "<auto>", mode = "x" },
			{ "<leader>", mode = { "n", "v" } },
		},
		spec = {
			{ "<leader>s", group = "Search" },
			{ "<leader>g", group = "Go To" },
			{ "<leader>d", group = "Diagnostics" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>b", group = "Buffers" },
			{ "<leader>w", group = "Windows" },
			{ "<leader>c", group = "Code Actioins" },
		},
	},
}
