return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search and open files in the cwd" })
		keymap.set(
			"n",
			"<leader>so",
			"<cmd>Telescope oldfiles<cr>",
			{ desc = "Search and open recently accessed files" }
		)
		keymap.set(
			"n",
			"<leader>sS",
			"<cmd>Telescope live_grep<cr>",
			{ desc = "Search for a string in all files in the cwd" }
		)
		keymap.set(
			"n",
			"<leader>ss",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "Search for occurrences of the string under the cursor in the cwd" }
		)
		keymap.set("n", "<leader>bf", function()
			builtin.buffers({
				ignore_current_buffer = true,
			})
		end, { desc = "List all open buffers, excluding the current buffer" })
	end,
}
