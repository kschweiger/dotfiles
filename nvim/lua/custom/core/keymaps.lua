-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>o", "o<ESC>", { desc = "Insert line below and jump to nex line" })
keymap.set("n", "<leader>O", "O<ESC>", { desc = "Insert line below" })

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

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
