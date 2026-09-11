-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")

local function reset_diagnostics(clients, bufnr)
  for _, client in ipairs(clients) do
    vim.diagnostic.reset(vim.lsp.diagnostic.get_namespace(client.id), bufnr)
  end
end

local function restart_lsp_servers()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if vim.bo[bufnr].filetype == "python" then
    local ok, venv_selector = pcall(require, "venv-selector")
    local has_selected_venv = ok and venv_selector.python()
    local managed_clients = vim.tbl_filter(function(client)
      return client.config and client.config._venv_selector
    end, clients)

    if has_selected_venv and #managed_clients > 0 then
      reset_diagnostics(managed_clients, bufnr)
      venv_selector.restart_lsp_servers()
      return
    end
  end

  reset_diagnostics(clients, bufnr)
  vim.cmd("lsp restart")
end

wk.add({
  { "<leader>tc", group = "Coverage" },
  { "<leader>o", "o<ESC>", desc = "Insert line below" },
  { "<leader>O", "O<ESC>", desc = "Insert line above" },
  { "<leader>L", "<cmd>Lazy restore<cr>", desc = "Run Lazy restore" },
  {
    "<leader>cu",
    restart_lsp_servers,
    desc = "Restart LSP Servers",
  },
})
vim.keymap.set("n", "#", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\<" .. word .. "\\>")
  vim.cmd("set hlsearch")
end, { desc = "Highlight word under cursor without moving" })
