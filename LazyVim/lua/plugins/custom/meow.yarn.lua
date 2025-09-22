return {
  "retran/meow.yarn.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("meow.yarn").setup({})
  end,
  keys = {
    { "<leader>y", "", desc = "+yarn", mode = { "n" } },
    {
      "<leader>yt",
      function()
        require("meow.yarn").open_tree("type_hierarchy", "supertypes")
      end,
      desc = "Yarn: Type Hierarchy (Super)",
      mode = { "n" },
    },
    {
      "<leader>yT",
      function()
        require("meow.yarn").open_tree("type_hierarchy", "subtypes")
      end,
      desc = "Yarn: Type Hierarchy (Sub)",
      mode = { "n" },
    },
    {
      "<leader>yc",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callers")
      end,
      desc = "Yarn: Call Hierarchy (Callers)",
      mode = { "n" },
    },
    {
      "<leader>yC",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callees")
      end,
      desc = "Yarn: Call Hierarchy (Callees)",
      mode = { "n" },
    },
  },
}
