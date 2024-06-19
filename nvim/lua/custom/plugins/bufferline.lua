return {
  "akinsho/bufferline.nvim",
  -- TEMP: Current release does not run with neovim >= 0.10:w
  -- branch = "main",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = { -- required(bufferline).setup(opts)
    options = {
      mode = "tabs",
      separator_style = "slant",
    },
  },
}
