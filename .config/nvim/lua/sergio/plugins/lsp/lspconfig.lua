return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds

				opts.desc = "Jumps to the place where the symbol (variable, function, class, etc.) is declared"
				keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Find All References to the Symbol Under Cursor"
				keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Opens a Telescope popup with all the definitions of the symbol under the cursor"
				keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Find Implementations of the Symbol Under Cursor"
				keymap.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Find The Type Definition of the Symbol Under Cursor"
				keymap.set("n", "<leader>ft", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "Show code actions"
				keymap.set({ "n", "v" }, "<leader>c", vim.lsp.buf.code_action, opts) --

				opts.desc = "Smart Rename"
				keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["gopls"] = function()
				-- configure Go language server (gopls)
				lspconfig["gopls"].setup({
					capabilities = capabilities, -- Pass the capabilities that enable autocompletion
					settings = {
						gopls = {
							analyses = {
								unusedparams = true, -- Enable analysis for unused parameters
								shadow = true, -- Enable shadowing variable analysis
							},
							staticcheck = true, -- Enable additional static checks
						},
					},
				})
			end,
			["golangci_lint_ls"] = function()
				lspconfig["golangci_lint_ls"].setup({
					capabilities = capabilities, -- Pass the capabilities that enable autocompletion
					filetypes = { "go", "gomod" }, -- Specify the file types this server should act on
				})
			end,
		})
	end,
}
