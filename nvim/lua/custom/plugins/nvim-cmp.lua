return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    --"L3MON4D3/LuaSnip", -- snippet engine
    --"saadparwaiz1/cmp_luasnip", -- for autocompletion
    --"rafamadriz/friendly-snippets", -- useful snippets
    --"onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")

    --local luasnip = require("luasnip")

    --local lspkind = require("lspkind")
    local select_opts = { behavior = cmp.SelectBehavior.Select }
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    --require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        --completeopt = { "menu", "menuone", "noselect" },
        -- autocomplete = false,
        completeopt = "menu,menuone,noselect",
      },
      --snippet = { -- configure how nvim-cmp interacts with snippet engine
      --  expand = function(args)
      --    luasnip.lsp_expand(args.body)
      --  end,
      --},
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

        --["<C-f>"] = cmp.mapping(function(fallback)
        --  if luasnip.jumpable(1) then
        --    luasnip.jump(1)
        --  else
        --    fallback()
        --  end
        --end, { "i", "s" }),

        --["<C-b>"] = cmp.mapping(function(fallback)
        --  if luasnip.jumpable(-1) then
        --    luasnip.jump(-1)
        --  else
        --    fallback()
        --  end
        --end, { "i", "s" }),
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
        { name = "nvim_lsp" },
        -- { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = "λ",
            luasnip = "⋗",
            buffer = "Ω",
            path = "🖫",
          }

          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
    })
  end,
}
