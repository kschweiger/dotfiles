return {
  "vim-test/vim-test",
  dependencies = { "preservim/vimux" },
  vim.keymap.set("n", "<leader>tt", ":Run nearest test<CR>"),
  vim.keymap.set("n", "<leader>tT", ":Run tests in file<CR>"),
  vim.keymap.set("n", "<leader>ta", ":Run test suite<CR>"),
  vim.keymap.set("n", "<leader>tl", ":Run last test<CR>"),
  vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>"),

  vim.cmd("let test#strategy = 'vimux'"),
}
