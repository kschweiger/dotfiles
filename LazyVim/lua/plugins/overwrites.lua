return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      enable_diagnostics = false,
      default_component_configs = {
        git_status = {
          symbols = { unstaged = "󰄯", staged = "󰄯" },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = { lualine_z = {} },
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = { experimental = {
  --     ghost_text = false,
  --   } },
  -- },
  {
    "ThePrimeagen/harpoon",
    keys = function()
      local keys = {
        {
          "<leader>a",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        { "<leader>h", "", desc = "harpoon", mode = { "n", "v" } },
        {
          "<leader>hm",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
        {
          "<leader>hd",
          function()
            local harpoon = require("harpoon")
            harpoon:list():remove()
          end,
          desc = "Remove harpooned file",
        },
        {
          "<leader>hc",
          function()
            local harpoon = require("harpoon")
            harpoon:list():clear()
          end,
          desc = "Clear harpooned files",
        },
      }
      for i = 1, 6 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },

    opts = { adapters = {
      ["neotest-python"] = {
        dap = { justMyCode = false },
      },
    } },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local dap = require("dap-python")
      dap.setup("python")
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO = { icon = "", color = "#3CB371" },
        WARN = { color = "#FFD700" },
        DONOTCOMMIT = { icon = "", color = "#DC143C" },
        NOTE = { icon = "", color = "#FFDAB9" },
        HACK = { alt = { "TEMP" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local function append_to_end_of_line(str)
        -- Get the current line number
        local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
        --     -- Get the current line contents
        local line = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
        --         -- Append the string
        local new_line = line .. str
        --             -- Set the updated line back in the buffer
        vim.api.nvim_buf_set_lines(0, line_num, line_num + 1, false, { new_line })
      end

      local type_ignore_python = {
        method = nls.methods.CODE_ACTION,
        filetypes = { "python" },
        generator = {
          fn = function(context)
            return {
              {
                title = "Add type: ignore",
                action = function()
                  append_to_end_of_line(" # type: ignore")
                end,
                -- action = function()
                --   local current_row = vim.api.nvim_win_get_cursor(0)[1]
                --   vim.api.nvim_buf_set_lines(0, current_row, current_row, true, { "# type: ignore" })
                -- end,
              },
            }
          end,
        },
      }

      nls.register(type_ignore_python)
      opts.sources = {}
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = function()
      return {
        { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },

        { "<leader>A", "", desc = "+ai", mode = { "n", "v" } },
        {

          "<leader>Aa",
          function()
            return require("CopilotChat").toggle()
          end,

          desc = "Toggle (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>Ax",
          function()
            return require("CopilotChat").reset()
          end,
          desc = "Clear (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>Aq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end,

          desc = "Quick Chat (CopilotChat)",
          mode = { "n", "v" },
        },
        {

          "<leader>Ad",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
          end,
          desc = "CopilotChat - Help actions",
        },
        -- Show prompts actions with telescope
        {
          "<leader>Ap",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end,

          desc = "CopilotChat - Prompt actions",
        },
      }
    end,
  },
  -- TEMP: Currently disabled because telescope was remove or something
  { "linux-cultist/venv-selector.nvim", enabled = true },
  { "nvim-telescope/telescope.nvim", enabled = true },
}
