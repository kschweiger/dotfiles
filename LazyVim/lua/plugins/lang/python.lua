return {
  { "linux-cultist/venv-selector.nvim", enabled = true },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },

    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          pytest_discover_instances = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local dap = require("dap-python")
      dap.setup("python")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" }, --"ruff_fix",
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
