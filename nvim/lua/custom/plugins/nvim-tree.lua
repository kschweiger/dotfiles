return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- configure nvim-tree
    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = false,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        git_ignored = true,
        custom = { ".DS_Store", "^.git$" },
      },
      git = {
        ignore = false,
      },
      update_focused_file = {
        enable = true,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local api = require("nvim-tree.api")
    keymap.set("n", "<leader>ee", api.tree.toggle, { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", api.tree.collapse_all, { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", api.tree.reload, { desc = "Refresh file explorer" }) -- refresh file explorer
    keymap.set("n", "<leader>eg", api.tree.toggle_gitignore_filter, { desc = "Toggle git ignored files and folders" })
  end,
}
