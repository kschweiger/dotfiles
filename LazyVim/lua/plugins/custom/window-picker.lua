return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    opts = {
      hint = "floating-big-letter",
      show_prompt = false,
      filter_rules = {
        autoselect_one = true,
        include_current_win = false,
        include_unfocusable_windows = false,
            -- stylua: ignore
            bo = {
              filetype = { "snacks_picker_input", "snacks_picker_list", "NvimTree", "neo-tree", "notify", "snacks_notif", },
              buftype = { "terminal", "nofile", "quickfix", "help", "prompt", "notify", "float" },
            },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            actions = {
              window_picker = function(_, item)
                if item.dir then
                  return
                end

                local window_id = require("window-picker").pick_window()

                if not window_id then
                  return
                end

                vim.api.nvim_set_current_win(window_id)
                vim.cmd("edit " .. item._path)
                -- Snacks.explorer()
              end,
            },
            win = {
              list = {
                keys = {
                  ["w"] = "window_picker",
                },
              },
            },
          },
        },
      },
    },
  },
}
