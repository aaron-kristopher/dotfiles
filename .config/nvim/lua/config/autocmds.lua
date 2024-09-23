-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local M = {}

function M.run_file()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand("%:p")

  local command
  if filetype == "python" then
    command = "python3 " .. filename
  elseif filetype == "javascript" then
    command = "node " .. filename
  elseif filetype == "lua" then
    command = "lua " .. filename
  else
    print("No run command defined for this file type.")
    return
  end

  os.execute("tmux split-window -h")
  os.execute('tmux send-keys "' .. command .. '" C-m')
end

-- Keybinding to trigger the run_file function
vim.api.nvim_set_keymap(
  "n",
  "<leader>r",
  ":lua require('autocmds.lua')run_file()<CR>",
  { noremap = true, silent = true }
)

return M
