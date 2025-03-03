return {
	"neovim/nvim-lspconfig", -- Core plugin for configuring LSP servers
	event = { "BufReadPre", "BufNewFile" }, -- Load this plugin on file read or creation
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- Autocompletion capabilities for LSP
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- File-related LSP features
		{ "folke/neodev.nvim", opts = {} }, -- Improved support for Lua development in Neovim
	},
	config = function()
		-- 1. Import required plugins
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- 2. Set up capabilities for autocompletion (used by all LSP servers)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- 3. Configure diagnostics signs in the gutter
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl })
		end

		-- 4. Define a function to set keybindings for LSP features
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				local keymap = vim.keymap.set

				keymap(
					"n",
					"<leader>fr",
					"<cmd>Telescope lsp_references<CR>",
					vim.tbl_extend("force", opts, { desc = "Find all references to the symbol under the cursor" })
				)

				keymap(
					"n",
					"<leader>gd",
					vim.lsp.buf.declaration,
					vim.tbl_extend("force", opts, { desc = "Go to the declaration of the symbol" })
				)

				keymap(
					"n",
					"<leader>fd",
					"<cmd>Telescope lsp_definitions<CR>",
					vim.tbl_extend("force", opts, { desc = "Find all definitions of the symbol under the cursor" })
				)

				keymap(
					"n",
					"<leader>fi",
					"<cmd>Telescope lsp_implementations<CR>",
					vim.tbl_extend("force", opts, { desc = "Find all implementations of the symbol under the cursor" })
				)

				keymap(
					"n",
					"<leader>ft",
					"<cmd>Telescope lsp_type_definitions<CR>",
					vim.tbl_extend("force", opts, { desc = "Find type definitions of the symbol under the cursor" })
				)

				keymap(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Show available code actions" })
				)

				keymap(
					"n",
					"<leader>cr",
					vim.lsp.buf.rename,
					vim.tbl_extend("force", opts, { desc = "Rename the symbol under the cursor" })
				)

				keymap(
					"n",
					"<leader>df",
					"<cmd>Telescope diagnostics bufnr=0<CR>",
					vim.tbl_extend("force", opts, { desc = "Show diagnostics for the current file" })
				)

				keymap(
					"n",
					"<leader>dl",
					vim.diagnostic.open_float,
					vim.tbl_extend("force", opts, { desc = "Show diagnostics for the current line" })
				)

				keymap(
					"n",
					"<leader>dp",
					vim.diagnostic.goto_prev,
					vim.tbl_extend("force", opts, { desc = "Jump to the previous diagnostic" })
				)

				keymap(
					"n",
					"<leader>dn",
					vim.diagnostic.goto_next,
					vim.tbl_extend("force", opts, { desc = "Jump to the next diagnostic" })
				)

				keymap(
					"n",
					"K",
					vim.lsp.buf.hover,
					vim.tbl_extend("force", opts, { desc = "Show documentation for the symbol under the cursor" })
				)

				keymap(
					"n",
					"<leader>ts",
					":LspRestart<CR>",
					vim.tbl_extend("force", opts, { desc = "Restart the LSP server" })
				)
			end,
		})

		-- 5. Set up Mason LSP handlers for servers
		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			-- Custom configurations for specific servers
			["emmet_ls"] = function()
				lspconfig.emmet_ls.setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							completion = { callSnippet = "Replace" },
						},
					},
				})
			end,
		})
	end,
}
