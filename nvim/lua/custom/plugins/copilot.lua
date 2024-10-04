return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false, -- Disable bc. cmp
          auto_trigger = true,
          keymap = {
            -- accept = "<C-Left><Tab>"
          },
        },
        panel = { enabled = false, auto_refresh = true },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
