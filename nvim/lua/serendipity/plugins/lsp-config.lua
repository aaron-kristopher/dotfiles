return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",

    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim",       opts = {} },

      "hrsh7th/cmp-nvim-lsp",
    },

    config = function() -- NOTE: Function for LSP
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", function()
            Snacks.picker.lsp_definitions()
          end, "[G]oto [D]efinition")

          map("gr", function()
            Snacks.picker.lsp_references()
          end, "[G]oto [R]eferences")

          map("gI", function()
            Snacks.picker.lsp_implementations()
          end, "[G]oto [I]mplementation")

          map("<leader>D", function()
            Snacks.picker.lsp_type_definitions()
          end, "Type [D]efinition")

          map("<leader>ds", function()
            Snacks.picker.lsp_symbols()
          end, "[D]ocument [S]ymbols")

          map("<leader>ws", function()
            Snacks.picker.lsp_workspace_symbols()
          end, "[W]orkspace [S]ymbols")

          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          map("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover details")

          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = event.buf,
              callback = function()
                if vim.g.disable_autoformat then
                  return
                end

                vim.lsp.buf.format({
                  bufnr = event.buf,
                  id = client.id,
                })
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "off", -- "off", "basic", "standard", "strict"
                diagnosticMode = "openFilesOnly",

                -- Relax common type hint requirements
                reportMissingTypeStubs = "none",
                reportUnknownParameterType = "none",
                reportUnknownArgumentType = "none",
                reportUnknownVariableType = "none",
                reportUnknownMemberType = "none",
                reportUnknownLambdaType = "none",
                reportUnknownReturnType = "none",
                reportAny = "none",
              },
            },
          },
        },

        kotlin_language_server = {},

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
