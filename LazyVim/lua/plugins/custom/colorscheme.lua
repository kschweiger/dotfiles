return {
  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    tag = "v2.0.0",

    config = function()
      require("flow").setup({})
    end,
  },
}
