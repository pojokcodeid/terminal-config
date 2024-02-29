-- buat file di home directory
-- contoh
-- C:\Users\PCode\.wezterm.lua
-- compu code dibawah ini :

-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
-- config for on load fullscreen
-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = wezterm.mux.spawn_window(cmd or {})
-- 	window:gui_window():toggle_fullscreen()
-- end)
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
local scheme = "tokyonight_night"
config.color_scheme = scheme
-- Obtain the definition of that color scheme
local scheme_def = wezterm.color.get_builtin_schemes()[scheme]
-- overide background color with #202020
local bg_custom = "#2e2e2e"
config.colors = {
	-- overide background color
	background = scheme_def.background,
	-- overide tab background color
	tab_bar = {
		active_tab = {
			bg_color = scheme_def.background,
			fg_color = scheme_def.foreground,
		},
		-- overide tab inactive background color
		inactive_tab = {
			bg_color = bg_custom,
			fg_color = scheme_def.foreground,
		},
		inactive_tab_edge = bg_custom,
	},
}
-- set config window frame title background
config.window_frame = {
	active_titlebar_bg = bg_custom,
	inactive_titlebar_bg = bg_custom,
}
config.tab_bar_at_bottom = false
config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
-- config.background = {
-- {
-- 	source = { File = "C:/Users/Asep/Pictures/wallpaper_tokyonight.png" },
-- 	horizontal_align = "Center",
-- 	vertical_align = "Middle",
-- 	-- height = "Contain",
-- 	-- width = "Contain",
-- 	-- repeat_x = "NoRepeat",
-- 	-- repeat_y = "NoRepeat",
-- 	opacity = 1,
-- },
-- 	{
-- 		source = { File = "C:/Users/Asep/Pictures/background_ps.png" },
-- 		opacity = 1,
-- 	},
-- }

config.exit_behavior = "Close"

-- and window padding:
config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 10,
}

-- add window size initial coll and row
config.initial_cols = 110
config.initial_rows = 30

-- config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "RESIZE"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- add opacity 0.9
config.window_background_opacity = 1
-- config.win32_system_backdrop = "Mica" -- Acrylic, Mica, or Tabbed

-- set window title text
wezterm.on("format-window-title", function(event)
	return ""
end)

-- add window title background color

-- set default terminal powershell
config.default_prog = { "pwsh.exe" }
-- set default cwd with current active directory
config.default_cwd = os.getenv("PWD") or os.getenv("OLDPWD")

-- activate font ligature
config.harfbuzz_features = { "liga=1" }
--[[ set font Hasklug Nerd font ]]
-- config.font = wezterm.font_with_fallback({
-- 	{ family = "Hasklug Nerd Font", weight = "Medium" },
-- })
config.font = wezterm.font({
	family = "Hasklug Nerd Font",
	weight = "Medium",
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = { "cv29", "cv30", "ss01", "ss03", "ss06", "ss07", "ss09" },
})
-- set font size 16
config.font_size = 15

-- add set line height
config.line_height = 1.1

config.disable_default_key_bindings = true
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true
-- config.hide_tab_bar_if_only_one_tab = true

-- set environment variable for current directory
config.set_environment_variables = {
	prompt = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ",
}
local current_dir = os.getenv("PWD") or os.getenv("OLDPWD")

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
		action = wezterm.action.SpawnCommandInNewTab({ args = { "pwsh.exe" }, cwd = current_dir }),
		mods = "CTRL|SHIFT",
		key = "T",
	},
	-- close active tab
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	-- open new window ctrl+shift+n
	{
		key = "n",
		mods = "ALT|SHIFT",
		action = wezterm.action.SpawnCommandInNewWindow({ args = { "pwsh.exe" }, cwd = current_dir }),
	},
	-- rename table title
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = wezterm.action.StartWindowDrag,
	},
	-- drag drop window CTRL + Mouse Left
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "CTRL|SHIFT",
		action = wezterm.action.StartWindowDrag,
	},
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
-- config.integrated_title_buttons = { "Close" }
config.scrollback_lines = 10000
config.show_update_window = true
config.use_dead_keys = false
config.unicode_version = 15
config.macos_window_background_blur = 100
config.window_close_confirmation = "NeverPrompt"
-- set cursor shape
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 700
-- and finally, return the configuration to wezterm
return config
