-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")
wk.add({
  { "<leader>ut", group = "themes" },
  { "<leader>ut1", "<cmd>colorscheme catppuccin-latte<cr>", desc = "Latte" },
  { "<leader>ut2", "<cmd>colorscheme catppuccin-macchiato<cr>", desc = "Macchiato" },
})