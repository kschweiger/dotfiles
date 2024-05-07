return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local wk = require("which-key")
      wk.register({
        h = {
          name = "git",
          -- Actions
          s = { gs.stage_hunk, "Stage Hunk" },
          r = { gs.reset_hunk, "Reset Hunk" },
          S = { gs.stage_buffer, "Stage Bugger" },
          R = { gs.reset_buffer, "Reset Buffer" },
          u = { gs.undo_stage_hunk, "Undo Stage Hunk" },
          p = { gs.preview_hunk, "Preview Hunk" },
          b = {
            function()
              gs.blame_line({ full = true })
            end,
            "Blame line",
          },
          B = { gs.toggle_current_line_blame, "Toggle line blame" },
          d = { gs.diffthis, "Diff this" },
          D = {
            function()
              gs.diffthis("~")
            end,
            "Diff this ~",
          },
        },
      }, { mode = "n", prefix = "<leader>" })

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
}
