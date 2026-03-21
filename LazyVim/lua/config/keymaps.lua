-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")
wk.add({
  { "<leader>tc", group = "Coverage" },
  { "<leader>o", "o<ESC>", desc = "Insert line below" },
  { "<leader>O", "O<ESC>", desc = "Insert line above" },
  { "<leader>L", "<cmd>Lazy restore<cr>", desc = "Run Lazy restore" },
  { "<leader>cu", "<cmd>LspRestart<cr>", desc = "Restart LSP Servers" },
})
vim.keymap.set("n", "#", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\<" .. word .. "\\>")
  vim.cmd("set hlsearch")
end, { desc = "Highlight word under cursor without moving" })
