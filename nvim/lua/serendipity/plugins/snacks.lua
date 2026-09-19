return {
	-- HACK: docs @ https://github.com/folke/snacks.nvim/blob/main/docs
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		-- NOTE: Options
		opts = {
			styles = {
				input = {
					keys = {
						n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
						i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
					},
				},
			},
			-- Snacks Modules
			input = {
				enabled = true,
			},
			quickfile = {
				enabled = true,
				exclude = { "latex" },
			},
			-- HACK: read picker docs @ https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
			picker = {
				enabled = true,
				matchers = {
					frecency = true,
					cwd_bonus = true,
				},
				exclude = {
					".git",
					"node_modules",
					"dist",
					"build",
				},
				formatters = {
					file = {
						filename_first = true,
						filename_only = false,
						icon_width = 2,
					},
				},
				layout = {
					-- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
					-- override picker layout in keymaps function as a param below
					preset = "telescope", -- defaults to this layout unless overidden
					cycle = false,
				},
				layouts = {
					select = {
						preview = false,
						layout = {
							backdrop = false,
							width = 0.6,
							min_width = 80,
							height = 0.4,
							min_height = 10,
							box = "vertical",
							border = "rounded",
							title = "{title}",
							title_pos = "center",
							{ win = "input",   height = 1,          border = "bottom" },
							{ win = "list",    border = "none" },
							{ win = "preview", title = "{preview}", width = 0.6,      height = 0.4, border = "top" },
						},
					},
					telescope = {
						reverse = true, -- set to false for search bar to be on top
						layout = {
							box = "horizontal",
							backdrop = false,
							width = 0.8,
							height = 0.9,
							border = "none",
							{
								box = "vertical",
								{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
								{
									win = "input",
									height = 1,
									border = "rounded",
									title = "{title} {live} {flags}",
									title_pos = "center",
								},
							},
							{
								win = "preview",
								title = "{preview:Preview}",
								width = 0.50,
								border = "rounded",
								title_pos = "center",
							},
						},
					},
					ivy = {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0,
							height = 0.4,
							position = "bottom",
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list",    border = "none" },
								{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
							},
						},
					},
				},
			},
			image = {
				enabled = function()
					return vim.bo.filetype == "markdown"
				end,
				doc = {
					float = false, -- show image on cursor hover
					inline = false, -- show image inline
					max_width = 50,
					max_height = 30,
					wo = {
						wrap = false,
					},
				},
				convert = {
					notify = true,
					command = "magick",
				},
				img_dirs = {
					"img",
					"images",
					"assets",
					"static",
					"public",
					"media",
					"attachments",
					"Archives/All-Vault-Images/",
					"~/Library",
					"~/Downloads",
				},
			},
			dashboard = {
				preset = {
					header = [[
 ▄▄▄▄ ▄▄▄▄  ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄  ▄▄ ▄▄▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄ ▄▄
███▄▄ ██▄█▄ ██▄▄  ███▄██ ██▀██ ██ ██▄█▀ ██   ██   ▀███▀
▄▄██▀ ██ ██ ██▄▄▄ ██ ▀██ ████▀ ██ ██    ██   ██     █   ]],
				},
				enabled = true,
				sections = {
					{ section = "header" },
					{
						pane = 2,
						section = "terminal",
						cmd = "colorscript -e square",
						height = 7,
						padding = 1,
					},
					{ section = "keys",  gap = 1, padding = 1 },
					{
						pane = 2,
						icon = " ",
						desc = "Browse Repo",
						padding = 1,
						key = "b",
						action = function()
							Snacks.gitbrowse()
						end,
					},
					function()
						local in_git = Snacks.git.get_root() ~= nil
						local cmds = {
							{
								title = "Notifications",
								cmd = "gh notify -s -a -n5",
								action = function()
									vim.ui.open("https://github.com/notifications")
								end,
								key = "n",
								icon = " ",
								height = 5,
								enabled = true,
							},
							{
								title = "Open Issues",
								cmd = "gh issue list -L 3",
								key = "i",
								action = function()
									vim.fn.jobstart("gh issue list --web", { detach = true })
								end,
								icon = " ",
								height = 7,
							},
							{
								icon = " ",
								title = "Open PRs",
								cmd = "gh pr list -L 3",
								key = "P",
								action = function()
									vim.fn.jobstart("gh pr list --web", { detach = true })
								end,
								height = 7,
							},
							{
								icon = " ",
								title = "Git Status",
								cmd = "git --no-pager diff --stat -B -M -C",
								height = 10,
							},
						}
						return vim.tbl_map(function(cmd)
							return vim.tbl_extend("force", {
								pane = 2,
								section = "terminal",
								enabled = in_git,
								padding = 1,
								ttl = 5 * 60,
								indent = 3,
							}, cmd)
						end, cmds)
					end,
					{ section = "startup" },
				},
			},
		},
		-- NOTE: Keymaps
		keys = {
			{
				"<leader>lg",
				function()
					require("snacks").lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gl",
				function()
					require("snacks").lazygit.log()
				end,
				desc = "Lazygit Logs",
			},
			{
				"<leader>rN",
				function()
					require("snacks").rename.rename_file()
				end,
				desc = "Fast Rename Current File",
			},
			{
				"<leader>dB",
				function()
					require("snacks").bufdelete()
				end,
				desc = "Delete or Close Buffer  (Confirm)",
			},

			-- Snacks Picker
			{
				"<leader>:",
				function()
					require("snacks").picker.command_history()
				end,
				desc = "Show command history",
			},
			{
				"<leader><space>",
				function()
					require("snacks").picker.files()
				end,
				desc = "Find Files (Snacks Picker)",
			},
			{
				"<leader>sb",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "[S]earch [B]uffers",
			},
			{
				"<leader>sc",
				function()
					require("snacks").picker.files({ cwd = vim.fn.getcwd() })
				end,
				desc = "[S]earch [C]urrent Working Directory",
			},
			{
				"<leader>sg",
				function()
					require("snacks").picker.grep()
				end,
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sig",
				function()
					require("snacks").picker.git_files()
				end,
				desc = "[S]earch [I]n [G]it-Files",
			},
			{
				"<leader>sh",
				function()
					require("snacks").picker.help()
				end,
				desc = "[S]earch [H]elp",
			},
			{
				"<leader>sk",
				function()
					require("snacks").picker.keymaps()
				end,
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>ss",
				function()
					require("snacks").picker.pickers()
				end,
				desc = "[S]earch [S]elect Pickers",
			},
			{
				"<leader>sw",
				function()
					require("snacks").picker.grep_word()
				end,
				desc = "[S]earch current [W]ord",
			},
			{
				"<leader>sd",
				function()
					require("snacks").picker.diagnostics()
				end,
				desc = "[S]earch [D]iagnostics [W]ord",
			},
			{
				"<leader>so",
				function()
					require("snacks").picker.recent()
				end,
				desc = "[S]earch [O]ldfiles",
			},
			{
				"<leader>fc",
				function()
					require("snacks").picker.files({ cwd = "~/.config/nvim/lua" })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>vh",
				function()
					require("snacks").picker.help()
				end,
				desc = "[V]im [H]elp pages",
			},

			-- Git Stuff
			{
				"<leader>gbr",
				function()
					require("snacks").picker.git_branches({ layout = "select" })
				end,
				desc = "Pick and Switch Git Branches",
			},

			{
				"<leader>spi",
				function()
					require("snacks").picker.files({
						cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
					})
				end,
				desc = "Find files from installed plugins",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		optional = true,
		keys = {
			{
				"<leader>spt",
				function()
					require("snacks").picker.todo_comments()
				end,
				desc = "All",
			},
			{
				"<leader>spT",
				function()
					require("snacks").picker.todo_comments({ keywords = { "TODO", "FORGETNOT", "FIXME" } })
				end,
				desc = "mains",
			},
		},
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			gitbrowse = {
				-- your gitbrowse configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},
	},
}
