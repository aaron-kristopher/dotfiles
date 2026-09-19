return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    -- end,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "vim",
        "vimdoc",
        "kotlin",
      },

      -- Autoinstall languages that are not installed
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },

      indent = {
        enable = true,
        disable = { "ruby" },
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = false,
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
