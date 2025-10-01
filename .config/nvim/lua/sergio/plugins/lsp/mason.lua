return {
	"mason-org/mason.nvim", -- Core Mason plugin for tool management
	dependencies = {
		"mason-org/mason-lspconfig.nvim", -- Mason support for LSP servers
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- Mason support for non-LSP tools (e.g., formatters, linters)
	},
	config = function()
		-- 1. Set up Mason UI with custom icons
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- 2. Install and manage LSP servers using Mason LSPconfig
		require("mason-lspconfig").setup({
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"gopls",
				"golangci_lint_ls",
			},
		})

		-- 3. Install and manage formatters and linters using Mason Tool Installer
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier", -- JS/TS formatter
				"stylua", -- Lua formatter
				"eslint_d", -- JS/TS linter
			},
		})
	end,
}
