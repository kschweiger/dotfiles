local commit_prompt_template = [[
#gitdiff:%s
$claude-sonnet-4

Write a concise commit message using the conventionalcommits format with one of the types: fix, refactor, feat, doc, or chore.
The message should contain a short title and a concise list of changes in the body.
Do not just describe what but also why.
Wrap the whole message in a code block with language gitcommit.
Use as much terminal-safe Unicode text-presentation emojis as possible in the title and the body.
]]
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
        {
          "<leader>Ac",
          function()
            require("CopilotChat").ask(string.format(commit_prompt_template, "staged"))
          end,
          desc = "Commit staged",
          mode = { "n", "v" },
        },
        {
          "<leader>As",
          function()
            local sha = vim.fn.input("Enter Git SHA to reference: ")
            if sha ~= "" then
              local final_prompt = string.format(commit_prompt_template, sha)
              require("CopilotChat").ask(final_prompt)
            end
          end,
          desc = "Commit with SHA (CopilotChat)",
          mode = { "n", "v" },
        },
      }
    end,
    opts = {
      -- model = "claude-3.7-sonnet-thought",
      model = "gemini-2.5-pro",
    },
  },
}
