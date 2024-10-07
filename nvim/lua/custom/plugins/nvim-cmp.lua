return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "L3MON4D3/LuaSnip", -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local types = require("cmp.types")
    local compare = require("cmp.config.compare")

    ---@type table<integer, integer>
    local modified_priority = {
      [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
      [types.lsp.CompletionItemKind.Snippet] = 0, -- top
      [types.lsp.CompletionItemKind.Keyword] = 0, -- top
      [types.lsp.CompletionItemKind.Text] = 100, -- bottom
    }
    ---@param kind integer: kind of completion entry
    local function modified_kind(kind)
      return modified_priority[kind] or kind
    end

    local select_opts = { behavior = cmp.SelectBehavior.Select }
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").load({ paths = "~/dotfiles/nvim/snippets" })
    cmp.setup({
      matching = {
        disallow_fuzzy_matching = true, -- default : false
        disallow_fullfuzzy_matching = true, -- default : false
        disallow_partial_fuzzy_matching = true, -- default : true
        disallow_partial_matching = false, -- default : false
        disallow_prefix_unmatching = true, -- default : false
        disallow_symbol_nonprefix_matching = true, -- default : true
      },
      performance = {
        debounce = 0,
        throttle = 0,
      },

      completion = {
        -- autocomplete = false,
        completeopt = "menu,menuone,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),

        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),

        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),

        ["<C-f>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-b>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          local col = vim.fn.col(".") - 1

          if cmp.visible() then
            cmp.select_next_item(select_opts)
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            fallback()
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      sorting = {
        -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
        comparators = {
          compare.offset,
          compare.exact,
          function(entry1, entry2) -- sort by length ignoring "=~"
            local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
            local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
            if len1 ~= len2 then
              return len1 - len2 < 0
            end
          end,
          compare.recently_used,
          function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
            local kind1 = modified_kind(entry1:get_kind())
            local kind2 = modified_kind(entry2:get_kind())
            if kind1 ~= kind2 then
              return kind1 - kind2 < 0
            end
          end,
          function(entry1, entry2) -- score by lsp, if available
            local t1 = entry1.completion_item.sortText
            local t2 = entry2.completion_item.sortText
            if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
              return t1 < t2
            end
          end,
          compare.score,
          compare.order,
        },
      },
      formatting = {
        format = lspkind.cmp_format({
          symbol_map = { Copilot = "" },
        }),
      },
    })
  end,
}
