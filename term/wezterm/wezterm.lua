local wezterm = require("wezterm")

local config = {}

-- Window settings
-- config.window_decorations = "NONE"
config.audible_bell = "Disabled"
config.term = "tmux-256color"
config.unicode_version = 14
config.adjust_window_size_when_changing_font_size = false
config.window_background_opacity = 0.99
config.color_scheme = "Catppuccin Frappe"
config.enable_tab_bar = false
config.window_padding = {
    left = 10,
    right = 10,
    top = 5,
    bottom = 10
}

-- Font settings
config.font_size = 10.5

config.font = wezterm.font_with_fallback({"JetBrainsMono Nerd Font Mono", "Symbols Nerd Font Mono"})

config.font_rules = {{
    intensity = "Normal",
    italic = false,
    font = wezterm.font_with_fallback({{
        family = "JetBrainsMono Nerd Font Mono",
        weight = "Medium",
        style = "Normal"
    }, "Symbols Nerd Font Mono"})
}, {
    intensity = "Bold",
    italic = false,
    font = wezterm.font_with_fallback({{
        family = "JetBrainsMono Nerd Font Mono",
        weight = "Bold",
        style = "Normal"
    }, "Symbols Nerd Font Mono"})
}, {
    intensity = "Half",
    italic = false,
    font = wezterm.font_with_fallback({{
        family = "JetBrainsMono Nerd Font Mono",
        weight = "Medium",
        style = "Normal"
    }, "Symbols Nerd Font Mono"})
}}

return config
