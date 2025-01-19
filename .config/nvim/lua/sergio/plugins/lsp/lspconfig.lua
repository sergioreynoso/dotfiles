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
		local on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, silent = true }
			local keymap = vim.keymap.set

			keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- Show references
			keymap("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration
			keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- Show definitions
			keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- Show implementations
			keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- Show type definitions
			keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
			keymap("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
			keymap("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- Show file diagnostics
			keymap("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show line diagnostics
			keymap("n", "[d", vim.diagnostic.goto_prev, opts) -- Go to previous diagnostic
			keymap("n", "]d", vim.diagnostic.goto_next, opts) -- Go to next diagnostic
			keymap("n", "K", vim.lsp.buf.hover, opts) -- Show hover documentation
			keymap("n", "<leader>rs", ":LspRestart<CR>", opts) -- Restart LSP server
		end

		-- 5. Set up Mason LSP handlers for servers
		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,
			-- Custom configurations for specific servers
			["svelte"] = function()
				lspconfig.svelte.setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["graphql"] = function()
				lspconfig.graphql.setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,
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
