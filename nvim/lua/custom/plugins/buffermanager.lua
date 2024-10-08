return {
  -- "j-morano/buffer_manager.nvim",
  "kschweiger/buffer_manager.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local buffer_manager = require("buffer_manager")
    local ui = require("buffer_manager.ui")
    buffer_manager.setup({
      short_file_names = true,
      short_term_names = true,
      width = 80,
      height = 20,
    })
    vim.keymap.set("n", "<leader>bl", function()
      ui.toggle_quick_menu()
    end, { desc = "List buffers" })
    vim.api.nvim_set_hl(0, "BufferManagerModified", { fg = "#f5bde6", bg = "#494d64" })
  end,
}
