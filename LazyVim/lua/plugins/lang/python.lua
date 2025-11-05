return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },

    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          pytest_discover_instances = true,
        },
      },
      discovery = {
        filter_dir = function(name, rel_path, root)
          -- Exclude the 'lib' directory from test discovery
          return name ~= "lib"
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local dap = require("dap-python")
      dap.setup("python")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" }, --"ruff_fix",
      },
    },
  },
  -- Example how to override LSP server settings
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       pyright = {
  --         settings = {
  --           pyright = {
  --             disableTaggedHints = true,
  --           },
  --           python = {
  --             analysis = {
  --               diagnosticSeverityOverrides = {
  --                 reportUnusedVariable = "error",
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
