return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		-- Minimal config
		require("themery").setup({
			themes = {
				"ayu",
				"gruvbox",
				"rose-pine",
				"kanagawa",
				"solarized-osaka",
				"tokyonight",
				"monokai-pro",
				"catppuccin",
				"everforest",
				"luna",
				"oldworld",
			},
			livePreview = true, -- Apply theme while picking. Default to true.
		})

		vim.keymap.set("n", "<leader>cs", "<CMD>Themery<CR>", { desc = "Change [C]olor[S]cheme" })
	end,
}
