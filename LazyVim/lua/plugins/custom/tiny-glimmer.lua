return {
  "rachartier/tiny-glimmer.nvim",
  event = "TextYankPost",
  opts = {
    default_animation = "bounce",
    animations = {
      fade = {
        -- Visual     -- active text selection highlight
        -- IncSearch  -- temporary yank highlight
        from_color = "Visual",
        to_color = "IncSearch",
      },
      bounce = {
        from_color = "Visual",
        to_color = "IncSearch",
      },
      left_to_right = {
        from_color = "Visual",
        to_color = "IncSearch",
      },
      pulse = {
        from_color = "Visual",
        to_color = "IncSearch",
      },
    },
  },
}
