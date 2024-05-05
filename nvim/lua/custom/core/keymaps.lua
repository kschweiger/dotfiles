-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- Pane Navigation
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader><left>", ":vertical resize +20<cr>", { desc = "Resize " })
vim.keymap.set("n", "<leader><right>", ":vertical resize -20<cr>", { desc = "Resize " })
vim.keymap.set("n", "<leader><up>", ":resize +10<cr>", { desc = "Resize " })
vim.keymap.set("n", "<leader><down>", ":resize -10<cr>", { desc = "Resize " })

vim.keymap.set("n", "<leader>bn", ":bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bp", ":bp<cr>", { desc = "Previous" })
vim.keymap.set("n", "<leader>bx", ":bd<cr>", { desc = "Delete" })
vim.keymap.set("n", "<leader>bm", ":b#<cr>", { desc = "Most Recent" })
