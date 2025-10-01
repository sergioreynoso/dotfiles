return {
	"neovim/nvim-lspconfig", -- Provides default LSP configurations for various servers
	event = { "BufReadPre", "BufNewFile" }, -- Load this plugin on file read or creation
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- Autocompletion capabilities for LSP
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- File-related LSP features
		{ "folke/neodev.nvim", opts = {} }, -- Improved support for Lua development in Neovim
		"mason.nvim", -- Ensure mason is loaded first
		"mason-lspconfig.nvim", -- Ensure mason-lspconfig is loaded
	},
	config = function()
		-- 1. Import required plugins
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- 2. Set up capabilities for autocompletion (used by all LSP servers)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- 3. Configure diagnostics signs in the gutter (Neovim 0.10+ API)
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

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
					"<leader>ci",
					":ImportUnderCursor<CR>",
					vim.tbl_extend("force", opts, { desc = "Import symbol under cursor" })
				)
			end,
		})

		-- 5. Configure LSP servers using vim.lsp.config() (Neovim 0.11+ API)
		-- Mason-lspconfig v2.0+ will automatically enable installed servers

		-- Configure servers with custom settings using vim.lsp.config()
		vim.lsp.config("emmet_ls", {
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

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			settings = {
				typescript = {
					suggest = {
						autoImports = true,
					},
				},
			},
			commands = {
				ImportUnderCursor = {
					function()
						local word = vim.fn.expand("<cword>")
						if word and word ~= "" then
							local params = vim.lsp.util.make_range_params()
							params.context = { only = { "source.addMissingImports" } }
							vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, actions)
								if err or not actions or vim.tbl_isempty(actions) then
									vim.notify("No import actions available", vim.log.levels.WARN)
								else
									vim.lsp.buf.execute_command(actions[1].command)
								end
							end)
						end
					end,
					description = "Import symbol under cursor",
				},
			},
		})

		vim.lsp.config("pylsp", {
			capabilities = capabilities,
			settings = {
				pylsp = {
					plugins = {
						pyflakes = { enabled = true }, -- linting: undefined names, etc.
						pycodestyle = { enabled = true }, -- linting: spacing, PEP8
						black = { enabled = true }, -- formatting
						isort = { enabled = true }, -- import sorting
						pylint = { enabled = false },
						mccabe = { enabled = false },
						yapf = { enabled = false },
						pylsp_mypy = { enabled = false },
					},
				},
			},
		})

		-- Configure all other servers with default capabilities
		local default_servers = {
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"graphql",
			"prismals",
			"gopls",
			"golangci_lint_ls",
		}

		for _, server_name in ipairs(default_servers) do
			vim.lsp.config(server_name, {
				capabilities = capabilities,
			})
		end
	end,
}
