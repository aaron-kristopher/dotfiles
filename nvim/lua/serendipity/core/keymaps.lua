local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without losing cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search previous and center cursor" })

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

vim.keymap.set("x", "n", "<Esc>", { desc = "Escape visual line mode" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode with Ctrl-c" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode with jk" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q key" })
vim.keymap.set("n", "<M-n>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer with LSP" })

vim.keymap.set("n", "<leader>l", function()
	vim.cmd("Lazy")
end, { desc = "Open Lazy Plugin Manager" })

vim.keymap.set("n", "<leader>x", "<cmd>source %<CR>", { desc = "Run entire file" })

vim.keymap.set("n", "<M-,>", "<c-w>5<", { desc = "Resize split to the right +5" })
vim.keymap.set("n", "<M-.>", "<c-w>5>", { desc = "Resize split to the right +5" })
vim.keymap.set("n", "<M-t>", "<c-w>2+", { desc = "Resize split to be [t]aller by +2" })
vim.keymap.set("n", "<M-s>", "<c-w>2-", { desc = "Resize split to be [s]horter by  -2" })

vim.keymap.set("n", "H", "<CMD>bprev<CR>", { desc = "Go to previous buffer in buffer list" })
vim.keymap.set("n", "L", "<CMD>bnext<CR>", { desc = "Go to next buffer in buffer list" })

vim.keymap.set("n", "<leader>q", "<CMD>lua vim.diagnostic.setqflist()<CR>", { desc = "Show [Q]uickfix List" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
