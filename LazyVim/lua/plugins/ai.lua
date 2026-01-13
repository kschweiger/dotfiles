local commit_prompt_template = [[
#gitdiff:%s
$claude-haiku-4.5

Generate a commit message in conventionalcommits format.

**Format:**
- Type: fix | refactor | feat | docs | chore
- Title: <type>: <emoji> <concise description> (max 50 chars)
- Body: Summarize key changes as a `-` bullet list (max depth 1)

**Rules:**
- Use `-` for all list items
- Include relevant Unicode emojis (text-safe) in title and body as much as possible
- Focus on intent/impact, not line-by-line changes
- Wrap output in ```gitcommit code block
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
