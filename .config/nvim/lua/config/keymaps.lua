-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Move selected lines down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- Move selected lines up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Join lines without losing cursor position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without losing cursor position" })

-- Scroll down and center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })

-- Scroll up and center cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

-- Search next and center cursor
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center cursor" })

-- Search previous and center cursor
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search previous and center cursor" })

-- Restart LSP server
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP server" })

-- Escape visual line mode
vim.keymap.set("x", "n", "<Esc>", { desc = "Escape visual line mode" })

-- Paste without yanking
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

-- Copy line to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Escape insert mode with Ctrl-c or jk
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode with Ctrl-c" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode with jk" })

-- Disable Q key
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q key" })

-- Format buffer with LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer with LSP" })

-- -- Keymap Override
-- vim.keymap.del("n", "<c-l>")
-- vim.keymap.del("n", "<c-h>")
-- vim.keymap.del("n", "<c-j>")
-- vim.keymap.del("n", "<c-k>")
--
-- Quick Fix

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- Navigate vim panes better
-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")

-- vim.keymap.set("n", "<leader><leader>", function()
--   vim.cmd("so")
-- end)
