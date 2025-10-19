-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
local api = vim.api

local spell_disable_filetypes = {
  "markdown",
  "text",
  -- "latex",
  -- "tex",
  -- "bib",
}

-- Create an autocommand group to ensure our commands are cleanly managed.
local nospell_group = api.nvim_create_augroup("NoSpellForProse", { clear = true })

-- Create the autocommand.
api.nvim_create_autocmd("FileType", {
  group = nospell_group,
  pattern = spell_disable_filetypes,
  desc = "Disable native spell checker for filetypes handled by LTeX.",
  callback = function()
    -- Use vim.opt_local to set the option for the current buffer only.
    vim.opt_local.spell = false
  end,
})

-- In your keymaps or autocmd
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>ci", function()
      local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
      local line = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
      vim.api.nvim_buf_set_lines(0, line_num, line_num + 1, false, { line .. " # type: ignore" })
    end, { buffer = true, desc = "Add type: ignore" })
  end,
})
