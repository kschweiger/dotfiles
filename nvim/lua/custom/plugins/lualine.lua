return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    lualine.setup({
      extensions = { "nvim-tree" },
      sections = {
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            always_visible = false,
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
          },
          "searchcount",
        },
        lualine_x = { "filetype" },
        lualine_z = {
          { "location" },
          {
            function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_get_option(buf, "modified") then
                  return "!" -- any message or icon
                end
              end
              return ""
            end,
          },
        },
      },
    })
  end,
}
