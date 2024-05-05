return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp", {
    "antosha417/nvim-lsp-file-operations",
    config = true,
  } },
  config = function()
    local lspconfig = require("lspconfig")

    local util = require("lspconfig/util")

    local mason_lspconfig = require("mason-lspconfig")

    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }
        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
        opts.desc = "Go to declaration"
        keymap.set("n", "gc", vim.lsp.buf.declaration, opts) -- go to declaration
        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Completion"
        keymap.set("i", "<C-i>", vim.lsp.buf.completion, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts) -- smart rename

        -- opts.desc = "References"
        -- keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>vdb", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>vdl", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "<leader>vch", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Signature Help"
        keymap.set({ "n", "v", "i" }, "<C-s>", vim.lsp.buf.signature_help, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = {
      Error = " ",
      Warn = " ",
      Hint = "󰠠 ",
      Info = " ",
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = "",
      })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
      ["pyright"] = function()
        lspconfig["pyright"].setup({
          capabilities = capabilities,
          settings = {
            disableOrganizeImports = false,
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
        })
      end,
      ["ruff_lsp"] = function()
        lspconfig["ruff_lsp"].setup({
          capabilities = capabilities,
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {
              "--ignore=I001",
            },
          },
        })
      end,
      ["html"] = function()
        lspconfig["html"].setup({
          capabilities = capabilities,
          filetypes = { "html", "htmldjango" },
        })
      end,
      ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({
          capabilities = capabilities,
          filetypes = { "rust" },
          root_dir = util.root_pattern("Cargo.toml"),
          settings = {
            ["rust_analyzer"] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        })
      end,
    })
  end,
}
