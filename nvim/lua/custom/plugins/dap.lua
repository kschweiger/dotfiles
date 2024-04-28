return {{
    "mfussenegger/nvim-dap",
    config = function()
        vim.keymap.set('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', {
            desc = "Step over"
        })
        vim.keymap.set('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', {
            desc = "Step into"
        })
        vim.keymap.set('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', {
            desc = "Step out"
        })
        vim.keymap.set('n', '<F5>', '<cmd>lua require"dap".continue()<CR>', {
            desc = "Start/continue"
        })
        vim.keymap.set('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', {
            desc = "Toggle Breakpoint"
        })
        vim.keymap.set('n', '<leader>dc',
            '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', {
                desc = "Set conditional breakpoint"
            })

        vim.keymap.set('n', '<leader>du', '<cmd>lua require"dapui".toggle()<CR>', {
            desc = "Toggle UI"
        })
        -- Active vs-code like launch.json support 
        -- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L323
        -- TODO: DO not look in the .vscode folder but a nvim specific folder 
        require('dap.ext.vscode').load_launchjs()
    end
}, {
    'rcarriga/nvim-dap-ui',
    dependencies = {'mfussenegger/nvim-dap', "nvim-neotest/nvim-nio"},
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup()

        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
        end

        dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
        end

        dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
        end
    end
}, {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {'williamboman/mason.nvim', 'mfussenegger/nvim-dap'},
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = {"python"}
        })
    end
}}
