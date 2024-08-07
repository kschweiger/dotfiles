return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xa", "<cmd>Trouble diagnostics toggle<cr>", desc = "Open/close trouble list" },
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle pinned=true results.win.relative=win results.win.position=right<cr>",
      desc = "Show symbols in buffer",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>",
      desc = "Open trouble document diagnostics",
    },
    { "<leader>xq", "<cmd>Trouble quickfix<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
  },
}
