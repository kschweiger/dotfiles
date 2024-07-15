return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Open/close trouble list" },
    -- { "<leader>xw", "<cmd>Trouble workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
    {
      "<leader>xd",
      "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>",
      desc = "Open trouble document diagnostics",
    },
    { "<leader>xq", "<cmd>Trouble quickfix<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
  },
}
