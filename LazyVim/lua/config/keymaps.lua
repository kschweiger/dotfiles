-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")
wk.add({
  { "<leader>tc", group = "Coverage" },
  { "<leader>ut", group = "themes" },
  { "<leader>ut1", "<cmd>colorscheme catppuccin-frappe<cr>", desc = "Frappe" },
  { "<leader>ut2", "<cmd>colorscheme catppuccin-macchiato<cr>", desc = "Macchiato" },
  { "<leader>ut3", "<cmd>colorscheme catppuccin-mocha<cr>", desc = "Mocha" },
  { "<leader>ut4", "<cmd>colorscheme catppuccin-latte<cr>", desc = "Latte" },
  { "<leader>ut5", "<cmd>colorscheme melange<cr>", desc = "Melange" },
  { "<leader>o", "o<ESC>", desc = "Insert line below" },
  { "<leader>O", "O<ESC>", desc = "Insert line above" },
})
