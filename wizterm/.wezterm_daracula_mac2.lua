
-- warna dasar
local bg_custom = "#363636" -- warna alternatif (titlebar lama)
local bg_color = "#282A36" -- background terminal (dracula)
local fg_inactive = "#999999" -- teks tab non-aktif

-- warna tab bar bergaya bufferline neovim
local tab_bar_bg = bg_color -- warna bar = warna background terminal (ganti ke bg_custom jika mau lebih terang)
local active_bg = "#44475a" -- warna pill tab aktif (coba "#3b4261" untuk gaya tokyonight)
local hover_bg = "#343746" -- warna pill saat hover tab non-aktif

config.colors = {
	background = bg_color,
	tab_bar = {
		background = tab_bar_bg,
		-- fancy tab bar: bentuk tab digambar WezTerm, warna diatur di sini
		active_tab = { bg_color = active_bg, fg_color = scheme_def.foreground },
		inactive_tab = { bg_color = tab_bar_bg, fg_color = fg_inactive },
		inactive_tab_hover = { bg_color = hover_bg, fg_color = scheme_def.foreground },
		inactive_tab_edge = tab_bar_bg,
		new_tab = { bg_color = tab_bar_bg, fg_color = scheme_def.foreground },
		new_tab_hover = { bg_color = hover_bg, fg_color = scheme_def.foreground },
	},
}

-- window frame (fancy tab bar)
config.window_frame = {
	active_titlebar_bg = tab_bar_bg,
	inactive_titlebar_bg = tab_bar_bg,
	-- font & ukuran tab bar (fancy tab bar)
	font = wezterm.font({ family = "Hasklug Nerd Font", weight = "Bold" }),
	font_size = 13,
}

-- Fancy tab bar: tombol "x" bawaan WezTerm berada di dalam tab dan bisa diklik
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.show_new_tab_button_in_tab_bar = true

----------------------------------------------------------------
-- TAB TITLE (rounded pill)
----------------------------------------------------------------
-- Ambil nama direktori terakhir dari path aktif
local function get_current_working_dir(tab)
	local current_dir = tab.active_pane.current_working_dir
	if current_dir then
		local path = current_dir.file_path
		-- Hapus trailing slash jika ada
		path = path:gsub("[/\\]$", "")
		-- Ambil komponen terakhir dari path
		local folder_name = path:match("([^/^\\]+)$")
		if folder_name and #folder_name > 0 then
			return folder_name
		end
	end
	return "Pojok Code"
end

-- Beri lebar minimum pada teks (padding spasi kiri-kanan)
local function pad_text(text, min_width)
	local len = #text
	if len >= min_width then
		return text
	end
	local total_padding = min_width - len
	local left_padding = math.floor(total_padding / 2)
	local right_padding = total_padding - left_padding
	return string.rep(" ", left_padding) .. text .. string.rep(" ", right_padding)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = get_current_working_dir(tab)
	if title == "asepkomarudin" then
		title = "Pojok Code"
	end
	-- hanya teks; warna mengikuti config.colors.tab_bar, tombol x dari WezTerm
	return " " .. pad_text(title, 16) .. " "
end)

config.tab_max_width = 28
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

----------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.exit_behavior = "Close"

config.window_padding = {
	left = 10,
	right = 10,
	top = 35,
	bottom = 10,
}

-- Perbarui top padding secara dinamis berdasarkan jumlah tab
wezterm.on("update-status", function(window, pane)
	local num_tabs = #window:mux_window():tabs()

	local top_padding = (num_tabs > 1) and 5 or 40

	local overrides = window:get_config_overrides() or {}
	local current_top = overrides.window_padding and overrides.window_padding.top or config.window_padding.top

	if current_top ~= top_padding then
		overrides.window_padding = {
			left = 10,
			right = 10,
			top = top_padding,
			bottom = 10,
		}
		window:set_config_overrides(overrides)
	end
end)

config.initial_cols = 110
config.initial_rows = 30

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }

config.window_background_opacity = 1
config.macos_window_background_blur = 100

-- kosongkan judul window
wezterm.on("format-window-title", function(event)
	return ""
end)

----------------------------------------------------------------
-- SHELL
----------------------------------------------------------------
config.default_prog = { "zsh" }
config.default_cwd = os.getenv("PWD")

config.set_environment_variables = {
	prompt = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ",
}
local current_dir = os.getenv("PWD")

----------------------------------------------------------------
-- FONT
----------------------------------------------------------------
config.harfbuzz_features = { "liga=1" }
config.font = wezterm.font({
	-- family = "FiraCode Nerd Font",
	family = "Hasklug Nerd Font",
	-- family = "JetBrainsMono Nerd Font",
	-- family = "SauceCodePro Nerd Font",
	weight = "DemiBold", -- Regular, Medium, Bold, DemiBold
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = { "cv29", "cv30", "ss01", "ss03", "ss06", "ss07", "ss09" },
})
config.freetype_load_flags = "NO_HINTING"
config.front_end = "Software" -- WebGpu or OpenGL or Software
config.font_size = 16
config.line_height = 1.3

----------------------------------------------------------------
-- MISC
----------------------------------------------------------------
config.scrollback_lines = 10000
config.use_dead_keys = false
config.unicode_version = 15
config.hide_mouse_cursor_when_typing = true

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.force_reverse_video_cursor = false

----------------------------------------------------------------
-- KEYS
----------------------------------------------------------------
config.disable_default_key_bindings = true

config.keys = {
	{ action = act.ActivateCommandPalette, mods = "CTRL|SHIFT", key = "P" },
	{ action = act.CopyTo("Clipboard"), mods = "CMD", key = "c" },
	{ action = act.DecreaseFontSize, mods = "CTRL", key = "-" },
	{ action = act.DecreaseFontSize, mods = "CMD", key = "-" },
	{ action = act.IncreaseFontSize, mods = "CTRL", key = "=" },
	{ action = act.IncreaseFontSize, mods = "CMD", key = "=" },
	{ action = act.Nop, mods = "ALT", key = "Enter" },
	{ action = act.PasteFrom("Clipboard"), mods = "CTRL", key = "v" },
	{ action = act.PasteFrom("Clipboard"), mods = "CMD", key = "v" },
	{ action = act.ResetFontSize, mods = "CTRL", key = "0" },
	{ action = act.ResetFontSize, mods = "CMD", key = "0" },
	{ action = act.ToggleFullScreen, key = "F11" },

	-- Buka tab baru mengikuti direktori pane aktif
	{ key = "T", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	-- close active tab
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	-- open new window
	{
		key = "n",
		mods = "ALT|SHIFT",
		action = act.SpawnCommandInNewWindow({ args = { "zsh" }, cwd = current_dir }),
	},
	-- rename tab title
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- move tab relative
	{ key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
	-- tab navigation
	{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
	-- split
	{ key = "v", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- close split
	{ key = "d", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	-- resize pane
	{ key = "UpArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },

	-- ALT + arrow dikirim ke aplikasi (neovim: ALT+k / ALT+j untuk move line)
	{ key = "UpArrow", mods = "ALT", action = act.SendKey({ key = "k", mods = "ALT" }) },
	{ key = "DownArrow", mods = "ALT", action = act.SendKey({ key = "j", mods = "ALT" }) },
	{ key = "LeftArrow", mods = "ALT", action = act.SendKey({ key = "LeftArrow", mods = "ALT" }) },
	{ key = "RightArrow", mods = "ALT", action = act.SendKey({ key = "RightArrow", mods = "ALT" }) },
	-- duplicate line ala vscode (shift+alt+up/down)
	{ key = "UpArrow", mods = "SHIFT|ALT", action = act.SendKey({ key = "UpArrow", mods = "SHIFT" }) },
	{ key = "DownArrow", mods = "SHIFT|ALT", action = act.SendKey({ key = "DownArrow", mods = "SHIFT" }) },

	-- Mapping CMD (macOS) -> CTRL agar terbaca di neovim
	{ key = "s", mods = "CMD", action = act.SendKey({ key = "s", mods = "CTRL" }) },
	{ key = "a", mods = "CMD", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "g", mods = "CMD", action = act.SendKey({ key = "g", mods = "CTRL" }) },
	{ key = "x", mods = "CMD", action = act.SendKey({ key = "x", mods = "CTRL" }) },
	{ key = "LeftArrow", mods = "CMD", action = act.SendKey({ key = "LeftArrow", mods = "CTRL" }) },
	{ key = "RightArrow", mods = "CMD", action = act.SendKey({ key = "RightArrow", mods = "CTRL" }) },
	{ key = "UpArrow", mods = "CMD", action = act.SendKey({ key = "UpArrow", mods = "CTRL" }) },
	{ key = "DownArrow", mods = "CMD", action = act.SendKey({ key = "DownArrow", mods = "CTRL" }) },
	{ key = "/", mods = "CMD", action = act.SendString("\x1f") },

	-- CTRL+x: cut jika ada seleksi, selain itu kirim ctrl+x
	{
		key = "x",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act.SendKey({ key = "x", mods = "CTRL" }), pane)
			end
		end),
	},
	-- CTRL+c: copy jika ada seleksi, selain itu kirim ctrl+c (interrupt)
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if not sel or sel == "" then
				window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
			else
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
			end
		end),
	},
}

----------------------------------------------------------------
-- MOUSE
----------------------------------------------------------------
config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = act.StartWindowDrag,
	},
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "CTRL|SHIFT",
		action = act.StartWindowDrag,
	},
	-- shift-click / ctrl-click membuka link di bawah kursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = act.OpenLinkAtMouseCursor,
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return config
