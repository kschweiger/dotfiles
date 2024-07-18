return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local wk = require("which-key")
        wk.add({
          { "<leader>h", group = "git" },
          { "<leader>hB", gs.toggle_current_line_blame, desc = "Toggle line blame" },
          {
            "<leader>hD",
            function()
              gs.diffthis("~")
            end,
            desc = "Diff this ~",
          },
          { "<leader>hR", gs.reset_buffer, desc = "Reset Buffer" },
          { "<leader>hS", gs.stage_buffe, desc = "Stage Bugger" },
          {
            "<leader>hb",
            function()
              gs.blame_line({ full = true })
            end,
            desc = "Blame line",
          },
          { "<leader>hd", gs.diffthis, desc = "Diff this" },
          { "<leader>hp", gs.preview_hunk, desc = "Preview Hunk" },
          { "<leader>hr", gs.reset_hunk, desc = "Reset Hunk" },
          { "<leader>hs", gs.stage_hunk, desc = "Stage Hunk" },
          { "<leader>hu", gs.undo_stage_hunk, desc = "Undo Stage Hunk" },
        })

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
      end,
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>hl", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}
