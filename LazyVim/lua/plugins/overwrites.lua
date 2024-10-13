return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
  {
    "ThePrimeagen/harpoon",
    keys = function()
      local keys = {
        {
          "<leader>h",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>Hm",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
        {
          "<leader>fd",
          function()
            local harpoon = require("harpoon")
            harpoon:list():remove()
          end,
          desc = "Remove harpooned file",
        },
        {
          "<leader>Hc",
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
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },

    opts = { adapters = {
      ["neotest-python"] = {
        dap = { justMyCode = false },
      },
    } },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local dap = require("dap-python")
      dap.setup("python")
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
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local function append_to_end_of_line(str)
        -- Get the current line number
        local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
        --     -- Get the current line contents
        local line = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
        --         -- Append the string
        local new_line = line .. str
        --             -- Set the updated line back in the buffer
        vim.api.nvim_buf_set_lines(0, line_num, line_num + 1, false, { new_line })
      end

      local type_ignore_python = {
        method = nls.methods.CODE_ACTION,
        filetypes = { "python" },
        generator = {
          fn = function(context)
            return {
              {
                title = "Add type: ignore",
                action = function()
                  append_to_end_of_line(" # type: ignore")
                end,
                -- action = function()
                --   local current_row = vim.api.nvim_win_get_cursor(0)[1]
                --   vim.api.nvim_buf_set_lines(0, current_row, current_row, true, { "# type: ignore" })
                -- end,
              },
            }
          end,
        },
      }

      nls.register(type_ignore_python)
      opts.sources = {}
    end,
  },
}
