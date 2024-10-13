return {
  "j-morano/buffer_manager.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    short_file_names = false,
    width = 80,
    height = 20,
  },
  keys = {
    {
      "<leader>bl",
      function()
        require("buffer_manager.ui").toggle_quick_menu()
      end,
      desc = "List Buffers",
      -- mode = { "n" },
    },
  },
  config = function(_, opts)
    require("buffer_manager").setup(opts)
    vim.api.nvim_set_hl(0, "BufferManagerModified", { fg = "#f5bde6", bg = "#494d64" })
  end,
}
