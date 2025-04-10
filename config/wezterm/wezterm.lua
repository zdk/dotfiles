local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_dirs = { "~/Library/Fonts/" }

config.color_scheme = "Everforest Light (Gogh)"

config.font = wezterm.font_with_fallback({
	"JetBrains Mono Light",
	"FiraCode Nerd Font Mono",
	"JetBrains Mono",
	"Fira Code",
})

config.font_size = 12
config.dpi = 144
config.max_fps = 240
config.enable_wayland = false
config.pane_focus_follows_mouse = false
config.warn_about_missing_glyphs = false

config.line_height = 1.0
config.send_composed_key_when_left_alt_is_pressed = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.initial_cols = 200
config.initial_rows = 100
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.8,
}
config.enable_scroll_bar = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_background_opacity = 1.0
config.tab_max_width = 50
config.hide_tab_bar_if_only_one_tab = true

config.adjust_window_size_when_changing_font_size = false
config.front_end = "OpenGL"

return config
