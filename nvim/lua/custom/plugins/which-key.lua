return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require("which-key")
    wk.register({
      b = { name = "Buffers" },
      t = { name = "Tabs" },
      x = { name = "Trouble " },
      d = { name = "Dap " },
      p = { name = "Python " },
      v = { name = "Vim Actions" },
      -- t = { name = "Test 󰤑" },
      f = { name = "Telescope " },
      e = { name = "File explorer " },
      m = { name = "Misc " },
    }, { mode = "n", prefix = "<leader>" })

    wk.setup({
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "󰁛 ", -- symbol prepended to a group
      },
    })
  end,
}
