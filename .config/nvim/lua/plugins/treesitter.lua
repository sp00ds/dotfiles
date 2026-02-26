return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		lazy = false,
		build = ":TSUpdate",  -- auto-download parser updates
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "python", "javascript", "typescript", "bash" }, -- languages to install
				highlight = {
					enable = true,		-- enable syntax highlighting
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,		-- smart indentation
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})
		end,
	},
}

