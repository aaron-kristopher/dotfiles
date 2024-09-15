-- Ensure catppuccin is loaded
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    prioity = 1000,
    config = function()
      require("catppuccin").setup({
        -- optional configuration
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          vim.cmd.colorscheme("catppuccin")
        end,
      })
    end,
  },
}
