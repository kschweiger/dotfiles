local text_fts = {
  "markdown",
  "text",
  -- "latex",
  -- "tex",
  -- "bib",
}

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "ltex-ls-plus" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex_plus = {
          settings = {
            ltex = {
              -- Set default language to German, but enable both.
              language = "de-DE",
            },
          },
          -- Define which filetypes the LTeX server should activate for.
          filetypes = text_fts,
          on_attach = function(client, bufnr)
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local basename = vim.fn.fnamemodify(filename, ":t")
            local excluded_files = { "prod.txt", "dev.txt", "test.txt" }
            vim.notify("LTeX attached to: " .. basename, vim.log.levels.INFO)
            if vim.tbl_contains(excluded_files, basename) then
              vim.notify("Detaching LTeX from excluded file: " .. basename, vim.log.levels.WARN)
              vim.lsp.buf_detach_client(bufnr, client.id)
              vim.schedule(function()
                client.stop()
              end)
              return false
            end
            vim.notify("LTeX will check: " .. basename, vim.log.levels.INFO)
          end,
        },
      },
    },
    keys = {
      {
        "<leader>cLg",
        function()
          local clients = vim.lsp.get_clients({ name = "ltex_plus", bufnr = 0 })
          if #clients > 0 then
            local client = clients[1]
            local new_settings = { ltex = { language = "de-DE" } }
            client.config.settings.ltex.language = "de-DE"
            client.notify("workspace/didChangeConfiguration", { settings = new_settings })
            vim.notify("LTeX language changed to German.", vim.log.levels.INFO)
          else
            vim.notify("LTeX server not active for this buffer.", vim.log.levels.WARN)
          end
        end,
        desc = "LSP: Set LTeX language to German",
        ft = text_fts,
      },
      {
        "<leader>cLe",
        function()
          local clients = vim.lsp.get_clients({ name = "ltex_plus", bufnr = 0 })
          if #clients > 0 then
            local client = clients[1]
            local new_settings = { ltex = { language = "en-US" } }
            client.config.settings.ltex.language = "en-US"
            client.notify("workspace/didChangeConfiguration", { settings = new_settings })
            vim.notify("LTeX language changed to English.", vim.log.levels.INFO)
          else
            vim.notify("LTeX server not active for this buffer.", vim.log.levels.WARN)
          end
        end,
        desc = "LSP: Set LTeX language to English",
        ft = text_fts,
      },
    },
  },
}
