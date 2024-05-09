-- NOTE: Does only work with >=0.10. Comment out if you use older versions
return {
  "MysticalDevil/inlay-hints.nvim",
  event = "LspAttach",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("inlay-hints").setup({
      -- commands = { enable = true },
      -- autocmd = { enable = false },
    })
  end,
}
