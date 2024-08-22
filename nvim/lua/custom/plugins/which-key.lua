return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>t", group = "Tabs" },
      { "<leader>x", group = "Trouble " },
      { "<leader>d", group = "Dap " },
      { "<leader>p", group = "Python " },
      { "<leader>v", group = "Vim Actions" },
      { "<leader>f", group = "Telescope " },
      { "<leader>e", group = "File explorer " },
      { "<leader>m", group = "Misc " },
      { "<leader>l", group = "LSP" },
      { "<leader>lc", group = "Code" },
      { "<leader>ld", group = "Diagnostics" },
      { "<leader>lh", group = "Hide" },
    })

    wk.setup({
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "󰁛 ", -- symbol prepended to a group
      },
    })
  end,
}
