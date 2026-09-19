return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		opts = function()
			-- PERF: avoid lualine's custom require wrapper
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			local icons = {
				diagnostics = {
					Error = " ",
					Warn = " ",
					Info = " ",
					Hint = "󰌵 ",
				},
				git = {
					added = " ",
					modified = " ",
					removed = " ",
				},
			}

			if vim.env.TMUX then
				vim.opt.laststatus = 0
			end

			return {
				options = {
					theme = "auto",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = {
						statusline = {
							"dashboard",
							"alpha",
							"ministarter",
						},
					},
				},

				sections = {
					lualine_a = { "mode" },

					lualine_b = {
						"branch",
					},

					lualine_c = {
						{
							function()
								return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
							icon = "󰉋",
						},

						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},

						{
							"filetype",
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},

						{
							"filename",
							path = 1,
						},
					},

					lualine_x = {
						{
							function()
								return require("noice").api.status.command.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.command.has()
							end,
						},

						{
							function()
								return require("noice").api.status.mode.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.mode.has()
							end,
						},

						{
							function()
								return " " .. require("dap").status()
							end,
							cond = function()
								return package.loaded["dap"] and require("dap").status() ~= ""
							end,
						},

						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
						},

						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},

							source = function()
								local gitsigns = vim.b.gitsigns_status_dict

								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
					},

					lualine_y = {
						{
							"progress",
							separator = " ",
							padding = { left = 1, right = 0 },
						},
						{
							"location",
							padding = { left = 0, right = 1 },
						},
					},

					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},

				extensions = {
					"neo-tree",
					"lazy",
					"fzf",
				},
			}
		end,
	},
}
