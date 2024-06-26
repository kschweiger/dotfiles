return {
  "j-morano/buffer_manager.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local buffer_manager = require("buffer_manager")
    local ui = require("buffer_manager.ui")
    buffer_manager.setup()
    vim.keymap.set("n", "<leader>bl", function()
      ui.toggle_quick_menu()
    end, { desc = "List buffers" })
  end,
}
