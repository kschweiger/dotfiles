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
    keys = {
      {
        "<leader>ac",
        function()
          require("CopilotChat").ask(string.format(commit_prompt_template, "staged"))
        end,
        desc = "Commit staged",
        mode = { "n", "v" },
      },
      {
        "<leader>as",
        function()
          local sha = vim.fn.input("Enter Git SHA to reference: ")
          if sha ~= "" then
            local final_prompt = string.format(commit_prompt_template, sha)
            require("CopilotChat").ask(final_prompt)
          end
        end,
        desc = "Commit with SHA",
        mode = { "n", "v" },
      },
      {
        "<leader>ar",
        "<cmd>CopilotChatReset<cr>",
        desc = "Reset Chat",
      },
    },
    opts = {
      model = "claude-sonnet-4.5",
    },
  },
}
