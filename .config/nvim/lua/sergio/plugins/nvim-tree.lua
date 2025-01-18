return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		-- Function to toggle focus on nvim-tree
		local function toggle_nvim_tree_focus()
			local api = require("nvim-tree.api")
			local view = require("nvim-tree.view")

			if view.is_visible() and vim.api.nvim_get_current_win() == view.get_winnr() then
				-- If the current window is nvim-tree, go back to the previous window
				vim.cmd("wincmd p")
			else
				-- Otherwise, focus on nvim-tree
				api.tree.focus()
			end
		end

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
		keymap.set("n", "<leader>ef", toggle_nvim_tree_focus, { desc = "Toggle focus on nvim-tree" }) -- toggle focus on nvim-tree
	end,
}
