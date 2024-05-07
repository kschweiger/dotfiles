return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
  ft = { "python" },
  config = function()
    -- local path = vim.fn.getcwd() .. '/.venv/bin/python'
    -- require('dap-python').setup(path)

    require("dap-python").setup()
  end,
}
