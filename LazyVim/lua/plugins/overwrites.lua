return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
  {
    "ThePrimeagen/harpoon",
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        { "<leader>h", "", desc = "harpoon", mode = { "n", "v" } },
        {
          "<leader>hm",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
        {
          "<leader>hd",
          function()
            local harpoon = require("harpoon")
            harpoon:list():remove()
          end,
          desc = "Remove harpooned file",
        },
        {
          "<leader>hc",
          function()
            local harpoon = require("harpoon")
            harpoon:list():clear()
          end,
          desc = "Clear harpooned files",
        },
      }
      for i = 1, 6 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO = { icon = "", color = "#3CB371" },
        WARN = { color = "#FFD700" },
        DONOTCOMMIT = { icon = "", color = "#DC143C" },
        NOTE = { icon = "", color = "#FFDAB9" },
        HACK = { alt = { "TEMP" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "select_and_accept" },
        ["<Tab>"] = { "select_next", "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        -- trigger = {
        --   show_on_blocked_trigger_characters = function()
        --     if vim.api.nvim_get_mode().mode == "c" then
        --       return {}
        --     end
        --
        --     if vim.bo.filetype == "python" then
        --       return { " ", "\n", "\t", ":" }
        --     end
        --     -- you can also block per filetype, for example:
        --     -- if vim.bo.filetype == 'markdown' then
        --     --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
        --     -- end
        --
        --     return { " ", "\n", "\t" }
        --   end,
        -- },
      },
    },
  },
  {
    "mistweaverco/kulala.nvim",
    opts = {
      default_env = "staging",
      ui = {
        max_response_size = 1048576,
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        treesitter = {
          labels = "asfghjklqwertuiozcbnm",
        },
      },
    },
  },
}
