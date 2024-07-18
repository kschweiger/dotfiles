return {
  "vim-test/vim-test",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "preservim/vimux" },
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>vt", group = "Test 󰤑" },
      { "<leader>vtT", ":TestFile<CR>", desc = "Run Tests in file" },
      { "<leader>vta", ":TestSuite<CR>", desc = "Run Test Suite" },
      { "<leader>vtg", ":TestVisit<CR>", desc = "Visit last test file" },
      { "<leader>vtl", ":TestLast<CR>", desc = "Run last test" },
      { "<leader>vtt", ":TestNearest<CR>", desc = "Run Nearest" },
    })
    vim.cmd("let test#strategy = 'vimux'")
  end,
}
