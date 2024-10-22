return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  keys = {
    {
      "<leader>tca",
      function()
        require("coverage").load(true)
      end,
      desc = "Activate code coverage",
    },
    {
      "<leader>tct",
      function()
        require("coverage").toggle()
      end,
      desc = "Toggle code coverage",
    },
    {
      "<leader>tcs",
      function()
        require("coverage").summary()
      end,
      desc = "Coverage Summary",
    },
  },
  opts = {},
}
