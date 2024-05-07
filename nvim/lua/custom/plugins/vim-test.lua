return {
  "vim-test/vim-test",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "preservim/vimux" },
  config = function()
    local wk = require("which-key")
    wk.register({
      t = {
        name = "Test 󰤑",
        -- Actions
        t = { ":TestNearest<CR>", "Run Nearest" },
        T = { ":TestFile<CR>", "Run Tests in file" },
        a = { ":TestSuite<CR>", "Run Test Suite" },
        l = { ":TestLast<CR>", "Run last test" },
        g = { ":TestVisit<CR>", "Visit last test file" },
      },
    }, { mode = "n", prefix = "<leader>v" })

    vim.cmd("let test#strategy = 'vimux'")
  end,
}
