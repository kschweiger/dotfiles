return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    local sources = {}
    null_ls = require("null-ls")

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
      method = null_ls.methods.CODE_ACTION,
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

    null_ls.register(type_ignore_python)

    null_ls.setup({ sources = sources, debug = true })
  end,
}
