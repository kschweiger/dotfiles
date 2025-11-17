return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Define a custom component for save status
    local function save_indicator()
      if vim.bo.modified then
        return "● unsaved" -- Red dot + text for modified buffers
      elseif vim.bo.modifiable == false then
        return "⊝ readonly" -- Readonly indicator
      else
        return "✓ saved" -- Checkmark for saved buffers
      end
    end

    -- Create the save indicator component
    local save_component = {
      save_indicator,
      color = function()
        if vim.bo.modified then
          return { fg = "#ff9e64", gui = "bold" } -- Orange/yellow for unsaved
        elseif vim.bo.modifiable == false then
          return { fg = "#565f89" } -- Gray for readonly
        else
          return { fg = "#9ece6a", gui = "bold" } -- Green for saved
        end
      end,
    }

    -- Insert the save indicator at the front of section C
    table.insert(opts.sections.lualine_x, save_component)

    -- Remove section Z
    opts.sections.lualine_z = {}

    return opts
  end,
}
