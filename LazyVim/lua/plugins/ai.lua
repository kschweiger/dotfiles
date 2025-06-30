return {
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
          "<leader>Ap",
          function()
            require("CopilotChat").select_prompt()
          end,
          desc = "Prompt Actions (CopilotChat)",
          mode = { "n", "v" },
        },
      }
    end,
    opts = {
      model = "claude-3.7-sonnet-thought",
      prompts = {
        Commit = {
          prompt = [[
> #git:staged
> $gpt-4.1

Write a consise commit message with the for the staged changes using the conventionalcommits with one of types fix, refactor, feat, doc, or chore. 
The message should contain a short title and a consise list of changes in the body
Wrap the whole message in code block with language gitcommit.
Use as much terminal-safe Unicode text-presentation emojis as possible in the title and the body.
]],
        },
        CommitFix = {
          prompt = [[
> #git:staged
> $gpt-4.1

The staged code is a fix for some issue. Write a consise commit message with the for the staged changes using the conventionalcommits.
The message should contain a short title and a consise list of changes in the body
Wrap the whole message in code block with language gitcommit.
Use as much terminal-safe Unicode text-presentation emojis as possible in the title and the body.
]],
        },
      },
    },
  },
}
