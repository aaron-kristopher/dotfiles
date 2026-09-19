return {
	{
		"nvim-mini/mini.surround",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			custom_surroundings = nil,
			highlight_duration = 300,

			-- Module mappings. Use `''` (empty string) to disable one.
			-- INFO:
			-- saiw surround with no whitespace
			-- saw surround with whitespace
			mappings = {
				add = "sa",
				delete = "ds",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",

				suffix_last = "l",
				suffix_next = "n",
			},

			-- Number of lines within which surrounding is searched
			n_lines = 20,

			respect_selection_type = false,
		},
	},

	{

		"nvim-mini/mini.trailspace",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local miniTrailspace = require("mini.trailspace")

			miniTrailspace.setup({
				only_in_normal_buffer = true,
			})

			vim.keymap.set("n", "<leader>cw", function()
				miniTrailspace.trim()
			end, { desc = "[C]lear [W]hitespaces." })

			-- Ensure highlight never reappears by removing it on CursorMoved
			vim.api.nvim_create_autocmd("CursorMoved", {
				pattern = "*",
				callback = function()
					require("mini.trailspace").unhighlight()
				end,
			})
		end,
	},

	{

		"nvim-mini/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			--  Check out: https://github.com/nvim-mini/mini.nvim
		end,
	},
	{
		"nvim-mini/mini.indentscope",
		config = function()
			require("mini.indentscope").setup({
				symbol = "│",
				options = {
					try_as_border = true,
					draw = {
						delay = 50,
					},
				},
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "yaml", "help", "oil", "txt", "themery" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "SnacksDashboardOpened",
				callback = function(data)
					vim.b[data.buf].miniindentscope_disable = true
				end,
			})
		end,
	},
}
