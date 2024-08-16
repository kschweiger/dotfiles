return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("coverage").setup()
    local wk = require("which-key")
    wk.add({
      { "<leader>vcc", group = "Coverage" },
    })
    vim.keymap.set("n", "<leader>vcca", function()
      require("coverage").load(true)
    end, { desc = "Activate code coverage" })
    vim.keymap.set("n", "<leader>vcct", function()
      require("coverage").toggle()
    end, { desc = "Toggle code coverage" })
  end,
}
