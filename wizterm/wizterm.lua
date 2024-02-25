-- Pull in the wezterm API
local wezterm = require("wezterm")

-- config for on load fullscreen
-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = wezterm.mux.spawn_window(cmd or {})
-- 	window:gui_window():toggle_fullscreen()
-- end)
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "tokyonight_night"
config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.background = {
	{
		source = { File = "C:/Users/Asep/Pictures/mycity.png" },
		opacity = 1,
	},
	{
		source = { File = "C:/Users/Asep/Pictures/tokyonight.png" },
		opacity = 0.85,
	},
}
config.exit_behavior = "Close"
-- config.font = wezterm.font({
-- 	family = "Hasklug Nerd Font",
-- 	weight = "Regular",
-- 	stretch = "Normal",
-- 	style = "Normal",
-- 	harfbuzz_features = { "cv29", "cv30", "ss01", "ss03", "ss06", "ss07", "ss09" },
-- })

-- and window padding:
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- add opacity 0.9
config.window_background_opacity = 0.9

-- set default terminal powershell
config.default_prog = { "pwsh.exe" }
-- set default cwd
config.default_cwd = wezterm.home_dir

-- Aktifkan ligatur
config.enable_csi_u_key_encoding = true
--[[ set font Hasklug Nerd font ]]
config.font = wezterm.font_with_fallback({
	{ family = "Hasklug Nerd Font", weight = "Regular" },
})
config.disable_default_key_bindings = true
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
config.keys = {
	{ action = wezterm.action.ActivateCommandPalette, mods = "CTRL|SHIFT", key = "P" },
	{ action = wezterm.action.CopyTo("Clipboard"), mods = "CTRL|SHIFT", key = "C" },
	{ action = wezterm.action.DecreaseFontSize, mods = "CTRL", key = "-" },
	{ action = wezterm.action.IncreaseFontSize, mods = "CTRL", key = "=" },
	{ action = wezterm.action.Nop, mods = "ALT", key = "Enter" },
	{ action = wezterm.action.PasteFrom("Clipboard"), mods = "CTRL|SHIFT", key = "V" },
	{ action = wezterm.action.ResetFontSize, mods = "CTRL", key = "0" },
	{ action = wezterm.action.ToggleFullScreen, key = "F11" },
	-- open new tab
	{
		action = wezterm.action.SpawnCommandInNewTab({ args = { "pwsh.exe" }, cwd = wezterm.home_dir }),
		mods = "CTRL|SHIFT",
		key = "T",
	},
	-- close active tab
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
}

config.scrollback_lines = 10000
config.show_update_window = true
config.use_dead_keys = false
config.unicode_version = 15
config.macos_window_background_blur = 100
config.window_close_confirmation = "NeverPrompt"

-- set font size 16
config.font_size = 17
-- set cursor shape
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 700
-- and finally, return the configuration to wezterm
return config
