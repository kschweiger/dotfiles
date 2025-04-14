return {
  {
    "catppuccin/nvim",
    opts = {
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay1 },
          CursorLineNr = { fg = colors.rosewater },
        }
      end,
      -- highlight_overrides = {
      --   frappe = function(frappe)
      --     return {
      --       LineNr = { fg = frappe.overlay1 },
      --       CursorLineNr = { fg = frappe.rosewater },
      --     }
      --   end,
      -- },
    },
  },
  { "savq/melange-nvim" },
}
