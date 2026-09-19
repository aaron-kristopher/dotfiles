return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
      "saadparwaiz1/cmp_luasnip",

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      local has_luasnip, luasnip = pcall(require, "luasnip")

      local rhs = function(keys)
        return vim.api.nvim_replace_termcodes(keys, true, true, true)
      end

      local lsp_kinds = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Operator = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      }

      local column = function()
        local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col
      end

      -- luasnip custom function
      local in_snippet = function()
        local session = require("luasnip.session")
        local node = session.current_nodes[vim.api.nvim_get_current_buf()]
        if not node then
          return false
        end
        local snippet = node.parent.snippet
        local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
        local pos = vim.api.nvim_win_get_cursor(0)
        if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
          return true
        end
      end

      -- returns true if the cursor is in leftmost column or at a whitespace char
      local in_whitespace = function()
        local col = column()
        return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
      end

      local in_leading_indent = function()
        local col = column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        return prefix:find("^%s*$")
      end

      -- custom shift width
      local shift_width = function()
        if vim.o.softtabstop <= 0 then
          return vim.fn.shiftwidth()
        else
          return vim.o.softtabstop
        end
      end

      -- custom smart backspace
      local smart_bs = function(dedent)
        local keys = nil
        if vim.o.expandtab then
          if dedent then
            keys = rhs("<C-D>")
          else
            keys = rhs("<BS>")
          end
        else
          local col = column()
          local line = vim.api.nvim_get_current_line()
          local prefix = line:sub(1, col)
          if in_leading_indent() then
            keys = rhs("<BS>")
          else
            local previous_char = prefix:sub(#prefix, #prefix)
            if previous_char ~= " " then
              keys = rhs("<BS>")
            else
              keys = rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
            end
          end
        end
        vim.api.nvim_feedkeys(keys, "nt", true)
      end

      -- custom smart tabs function
      local smart_tab = function(opts)
        local keys = nil
        if vim.o.expandtab then
          keys = "<Tab>" -- Neovim will insert spaces.
        else
          local col = column()
          local line = vim.api.nvim_get_current_line()
          local prefix = line:sub(1, col)
          local in_leading_indent = prefix:find("^%s*$")
          if in_leading_indent then
            -- inserts a hard tab.
            keys = "<Tab>"
          else
            local sw = shift_width()
            local previous_char = prefix:sub(#prefix, #prefix)
            local previous_column = #prefix - #previous_char + 1
            local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
            local remainder = (current_column - 1) % sw
            local move = remainder == 0 and sw or sw - remainder
            keys = (" "):rep(move)
          end
        end

        vim.api.nvim_feedkeys(rhs(keys), "nt", true)
      end

      local select_next_item = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end

      local select_prev_item = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end

      -- Until https://github.com/hrsh7th/nvim-cmp/issues/1716
      -- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
      -- to choose between `cmp.ConfirmBehavior.Insert` and
      -- `cmp.ConfirmBehavior.Replace`:
      local confirm = function(entry)
        local behavior = cmp.ConfirmBehavior.Replace
        if entry then
          local completion_item = entry.completion_item
          local newText = ""
          if completion_item.textEdit then
            newText = completion_item.textEdit.newText
          elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
            newText = completion_item.insertText
          else
            newText = completion_item.word or completion_item.label or ""
          end

          -- How many characters will be different after the cursor position if we
          -- replace?
          local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col

          -- Does the text that will be replaced after the cursor match the suffix
          -- of the `newText` to be inserted? If not, we should `Insert` instead.
          if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
            behavior = cmp.ConfirmBehavior.Insert
          end
        end
        cmp.confirm({ select = true, behavior = behavior })
      end

      cmp.setup({
        experimental = {
          -- See also `toggle_ghost_text()` below.
          ghost_text = true,
        },

        formatting = {
          -- See: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
          format = function(entry, vim_item)
            -- Set `kind` to "$icon $kind".
            vim_item.kind = string.format("%s %s", lsp_kinds[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            if has_luasnip then
              luasnip.lsp_expand(args.body)
            end
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-m>"] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          ["<C-Space>"] = cmp.mapping.complete({}),

          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<C-d>"] = cmp.mapping(function()
            cmp.close_docs()
          end, { "i", "s" }),

          -- Move right of completion
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),

          -- Move left of completion
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif in_leading_indent() then
              smart_bs(true) -- true means to dedent
            elseif in_whitespace() then
              smart_bs()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<Tab>"] = cmp.mapping(function(_fallback)
            if cmp.visible() then
              -- if there is only one completion candidate then use it.
              local entries = cmp.get_entries()
              if #entries == 1 then
                confirm(entries[1])
              else
                cmp.select_next_item()
              end
            elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif in_whitespace() then
              smart_tab()
            else
              cmp.complete()
            end
          end, { "i", "s" }),
          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        sources = cmp.config.sources({

          {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "calc" },
          { name = "emoji" },
          { name = "path" },
        }),
        window = {
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          },
          completion = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          },
        },
      })

      local config = require("cmp.config")

      local toggle_ghost_text = function()
        if vim.api.nvim_get_mode().mode ~= "i" then
          return
        end

        local cursor_column = vim.fn.col(".")
        local current_line_contents = vim.fn.getline(".")
        local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

        local should_enable_ghost_text = character_after_cursor == ""
            or vim.fn.match(character_after_cursor, [[\k]]) == -1

        local current = config.get().experimental.ghost_text
        if current ~= should_enable_ghost_text then
          config.set_global({
            experimental = {
              ghost_text = should_enable_ghost_text,
            },
          })
        end
      end

      vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
        callback = toggle_ghost_text,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
