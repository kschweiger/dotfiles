return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },

    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false, subProcess = false },
          pytest_discover_instances = true,
        },
      },
      discovery = {
        filter_dir = function(name, rel_path, root)
          return name ~= "lib"
        end,
        -- concurrent = 4,
        enabled = false,
        concurrent = 1,
      },
      running = {
        concurrent = false,
      },
    },
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
