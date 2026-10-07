-- Simpan di home directory: ~/.wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

----------------------------------------------------------------
-- COLOR SCHEME
----------------------------------------------------------------
-- local scheme = "tokyonight_night"
-- local scheme = "nightfox"
-- local scheme = "JetBrains Darcula"
-- local scheme = "OneDark (base16)"
-- local scheme = "GitHub Dark"
local scheme = "Dracula (Official)"
config.color_scheme = scheme

-- Obtain the definition of that color scheme
local scheme_def = wezterm.color.get_builtin_schemes()[scheme]

-- warna dasar
local bg_custom = "#363636" -- warna alternatif (titlebar lama)
local bg_color = "#282A36" -- background terminal (dracula)
local fg_inactive = "#999999" -- teks tab non-aktif

-- warna tab bar bergaya bufferline neovim
local tab_bar_bg = bg_color -- warna bar = warna background terminal (ganti ke bg_custom jika mau lebih terang)
local active_bg = "#44475a" -- warna pill tab aktif (coba "#3b4261" untuk gaya tokyonight)
local hover_bg = "#343746" -- warna pill saat hover tab non-aktif

-- Gaya tab:
--   "pill"   = rounded penuh seperti bufferline neovim (tombol x hanya tampilan, tidak bisa diklik)
--   "native" = tab bawaan WezTerm (sudut atas membulat), tombol x bisa diklik
local TAB_STYLE = "pill"

config.colors = {
	background = bg_color,
	tab_bar = {
		background = tab_bar_bg,
		active_tab = {
			bg_color = (TAB_STYLE == "native") and active_bg or tab_bar_bg,
			fg_color = scheme_def.foreground,
		},
		inactive_tab = { bg_color = tab_bar_bg, fg_color = fg_inactive },
		inactive_tab_hover = {
			bg_color = (TAB_STYLE == "native") and hover_bg or tab_bar_bg,
			fg_color = scheme_def.foreground,
		},
		inactive_tab_edge = tab_bar_bg,
		new_tab = { bg_color = tab_bar_bg, fg_color = scheme_def.foreground },
		new_tab_hover = { bg_color = hover_bg, fg_color = scheme_def.foreground },
	},
}

config.window_frame = {
	active_titlebar_bg = tab_bar_bg,
	inactive_titlebar_bg = tab_bar_bg,
	-- font & ukuran tab bar (hanya dipakai mode native/fancy)
	font = wezterm.font({ family = "Hasklug Nerd Font", weight = "Bold" }),
	font_size = 13,
}

if TAB_STYLE == "pill" then
	-- retro tab bar: bentuk tab sepenuhnya dikontrol format-tab-title
	config.use_fancy_tab_bar = false
	-- jarak dari atas (border atas berwarna sama dengan tab bar)
	config.window_frame.border_top_height = "0.4cell"
	config.window_frame.border_top_color = tab_bar_bg
else
	-- fancy tab bar: tombol x bawaan WezTerm bisa diklik
	config.use_fancy_tab_bar = true
	config.show_close_tab_button_in_tabs = true
	config.show_new_tab_button_in_tab_bar = true
end

----------------------------------------------------------------
-- TAB TITLE (rounded pill)
----------------------------------------------------------------
-- Ambil nama direktori terakhir dari path aktif
-- Nama tab dari cwd (dipakai tab bar DAN modal close tab, supaya penamaannya sama)
-- cwd bisa berupa Url object (punya .file_path), string, atau nil
local function dir_name_from_cwd(cwd)
	local path = nil
	if type(cwd) == "string" then
		path = cwd:gsub("^file://[^/]*", "")
	elseif cwd then
		path = cwd.file_path
	end
	if not path then
		return nil
	end
	-- Hapus trailing slash jika ada
	path = path:gsub("[/\\]$", "")
	-- Ambil komponen terakhir dari path
	local folder_name = path:match("([^/^\\]+)$")
	if folder_name and #folder_name > 0 then
		if folder_name == "asepkomarudin" then
			return "Pojok Code"
		end
		return folder_name
	end
	return nil
end

-- Cache nama tab terakhir yang valid, per tab_id.
-- Saat overlay (modal close tab, command palette, dll.) terbuka, pane aktif tab
-- diganti pane overlay yang tidak punya cwd, sehingga nama tab tidak boleh ikut berubah.
local tab_title_cache = {}

-- Dipakai tab bar DAN modal close tab, supaya penamaannya selalu sama
local function tab_name(tab_id, cwd)
	local name = dir_name_from_cwd(cwd)
	if name then
		tab_title_cache[tab_id] = name
		return name
	end
	return tab_title_cache[tab_id] or "Pojok Code"
end

-- Nama tab yang "dibekukan" selama overlay terbuka: { [tab_id] = { pane_id = <pane asli>, name = "..." } }
-- Overlay (modal) mengganti pane aktif tab dengan pane lain, jadi cwd-nya tidak bisa dipercaya.
local frozen_titles = {}

local function freeze_tab_title(window)
	local tab = window:active_tab()
	local pane = window:active_pane()
	local id = tab:tab_id()
	frozen_titles[id] = {
		pane_id = pane:pane_id(),
		name = tab_name(id, pane:get_current_working_dir()),
	}
end

local function get_current_working_dir(tab)
	local f = frozen_titles[tab.tab_id]
	if f then
		if tab.active_pane.pane_id == f.pane_id then
			-- pane asli sudah kembali aktif (overlay ditutup): lepas pembekuan
			frozen_titles[tab.tab_id] = nil
		else
			return f.name
		end
	end
	return tab_name(tab.tab_id, tab.active_pane.current_working_dir)
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

local LEFT_ROUND = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_ROUND = wezterm.nerdfonts.ple_right_half_circle_thick
local CLOSE_ICON = wezterm.nerdfonts.md_close

-- Bangun satu pill: [ rounded kiri | judul + x | rounded kanan ]
local function build_pill(title, pill_bg, text_fg, close_fg)
	return {
		{ Background = { Color = tab_bar_bg } },
		{ Foreground = { Color = pill_bg } },
		{ Text = LEFT_ROUND },
		{ Background = { Color = pill_bg } },
		{ Foreground = { Color = text_fg } },
		{ Text = title },
		{ Foreground = { Color = close_fg } },
		-- { Text = " " .. CLOSE_ICON .. " " },
		{ Background = { Color = tab_bar_bg } },
		{ Foreground = { Color = pill_bg } },
		{ Text = RIGHT_ROUND },
	}
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = get_current_working_dir(tab)
	if title == "asepkomarudin" then
		title = "Pojok Code"
	end

	-- nomor tab (dipakai untuk Cmd+Shift+W)
	local num = tostring(tab.tab_index + 1)

	if TAB_STYLE == "native" then
		-- hanya teks; warna & tombol x ditangani WezTerm
		return TAB_STYLE == "native" and pad_text(title, 14) .. " " or pad_text(" " .. num .. ":" .. title, 14) .. " "
	end

	-- title = pad_text("  " .. num .. ":" .. title, 14)
	local open_title = pad_text("  " .. num .. ":" .. title, 14)
	local close_title = pad_text("  " .. num .. ":" .. title, 14)

	if tab.is_active then
		return build_pill(open_title, active_bg, scheme_def.foreground, fg_inactive)
	end
	if hover then
		return build_pill(open_title, hover_bg, scheme_def.foreground, "#ff5555")
	end
	return {
		{ Background = { Color = tab_bar_bg } },
		{ Foreground = { Color = fg_inactive } },
		{ Text = " " .. close_title .. " " },
	}
end)

config.tab_max_width = 28
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

----------------------------------------------------------------
-- RESTORE LAST WINDOW POSITION & SIZE
----------------------------------------------------------------
-- PENTING: file state HARUS di luar folder yang berisi .wezterm.lua.
-- WezTerm memantau folder config; kalau ada file berubah di folder yang sama
-- (misal ~/), config otomatis di-reload terus-menerus.
local state_dir = wezterm.home_dir .. "/.local/state/wezterm"
local state_file = state_dir .. "/window-state.json"
pcall(wezterm.run_child_process, { "mkdir", "-p", state_dir })

local function read_state()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	if not content or content == "" then
		return nil
	end
	local ok, parsed = pcall(wezterm.json_parse, content)
	if ok then
		return parsed
	end
	return nil
end

local last_saved = ""
local restore_guard_until = 0 -- selama restore berlangsung, jangan simpan state

-- Skala koordinat posisi saat restore. osascript memberi satuan "points".
-- Jika setelah restart window muncul di posisi yang salah (misal setengah
-- jaraknya dari pojok kiri atas), ubah jadi 2 (atau 0.5 jika kebalikannya).
local POSITION_SCALE = 1

-- Posisi window dibaca lewat osascript di background (tidak memblokir UI).
-- Hasilnya ditulis ke file, lalu dibaca pada polling berikutnya.
local pos_file = state_dir .. "/position.txt"
local last_poll = 0
local cur_x, cur_y

local function poll_position()
	-- baca hasil polling terakhir (murah, dilakukan di setiap panggilan)
	local f = io.open(pos_file, "r")
	if f then
		local c = f:read("*a")
		f:close()
		local x, y = c:match("(-?%d+)%s*,%s*(-?%d+)")
		if x and y then
			cur_x, cur_y = tonumber(x) * POSITION_SCALE, tonumber(y) * POSITION_SCALE
		end
	end

	-- jalankan polling baru tiap 2 detik (butuh izin Accessibility untuk WezTerm)
	local now = os.time()
	if now - last_poll < 2 then
		return
	end
	last_poll = now
	wezterm.background_child_process({
		"sh",
		"-c",
		"osascript -e 'tell application \"System Events\" to tell process \"wezterm-gui\" to get position of window 1' > '"
			.. pos_file
			.. "' 2>/dev/null",
	})
end

-- dipanggil dari update-status & window-resized; hanya menulis file jika ada perubahan
local function save_state(window, pane)
	if os.time() < restore_guard_until then
		return
	end
	local dims = window:get_dimensions()
	if dims.is_full_screen then
		return
	end

	-- WezTerm tidak punya API untuk membaca posisi window, jadi posisi
	-- diambil lewat osascript (lihat poll_position di atas).
	poll_position()

	local pdims = pane:get_dimensions()
	local encoded = wezterm.json_encode({
		x = cur_x,
		y = cur_y,
		cols = pdims.cols,
		rows = pdims.viewport_rows,
	})

	if encoded == last_saved then
		return
	end
	last_saved = encoded

	local f, err = io.open(state_file, "w")
	if f then
		f:write(encoded)
		f:close()
	else
		wezterm.log_error("gagal menulis " .. state_file .. ": " .. tostring(err))
	end
end

-- ukuran awal (kolom/baris) dari state terakhir
local saved = read_state()
if saved and saved.cols and saved.rows then
	config.initial_cols = saved.cols
	config.initial_rows = saved.rows
end

-- posisi awal: spawn_window(position=...) diabaikan macOS, jadi window
-- dipindahkan setelah dibuat lewat osascript (System Events).
wezterm.on("gui-startup", function(cmd)
	local args = cmd or {}
	local s = read_state()
	local restore = nil
	if s and s.x and s.y then
		-- pastikan posisi tersimpan masih berada di dalam area layar yang
		-- terhubung (mis. monitor 2 sudah dicabut -> pakai posisi default)
		local on_screen = true
		local ok, screens = pcall(function()
			return wezterm.gui.screens()
		end)
		if ok and screens and screens.virtual_width then
			local min_x = screens.origin_x or 0
			local min_y = screens.origin_y or 0
			local max_x = min_x + screens.virtual_width
			local max_y = min_y + screens.virtual_height
			on_screen = s.x >= min_x - 50 and s.x < max_x - 100 and s.y >= min_y - 50 and s.y < max_y - 100
		end
		if on_screen then
			restore = { x = s.x, y = s.y }
			args.position = { x = s.x, y = s.y, origin = "ScreenCoordinateSystem" }

			-- Cari monitor yang berisi titik tersimpan, lalu pakai koordinat
			-- relatif ke monitor itu (origin = Named). Ini lebih andal di macOS
			-- daripada ScreenCoordinateSystem dan membuat window langsung muncul
			-- di monitor yang benar tanpa "lompat".
			if ok and screens and screens.by_name then
				for name, v in pairs(screens.by_name) do
					local sc = (v.scale and v.scale > 0) and v.scale or 1
					local w, h = v.width / sc, v.height / sc -- ukuran dalam points
					if s.x >= v.x and s.x < v.x + w and s.y >= v.y and s.y < v.y + h then
						args.position = { x = s.x - v.x, y = s.y - v.y, origin = { Named = name } }
						break
					end
				end
			end
		end
	end

	wezterm.mux.spawn_window(args)

	if restore then
		-- jangan timpa file state dengan posisi sementara saat window dipindahkan
		restore_guard_until = os.time() + 6
		-- tunggu window muncul, lalu pindahkan (coba 2x agar lebih andal)
		local script = string.format(
			'tell application "System Events" to tell process "wezterm-gui" to set position of window 1 to {%d, %d}',
			restore.x,
			restore.y
		)
		wezterm.background_child_process({
			"sh",
			"-c",
			"sleep 0.15; osascript -e '" .. script .. "' >/dev/null 2>&1; sleep 0.5; osascript -e '" .. script .. "' >/dev/null 2>&1",
		})
	end
end)

-- simpan juga saat di-resize
wezterm.on("window-resized", function(window, pane)
	save_state(window, pane)
end)

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
	bottom = 5,
}

-- Perbarui top padding secara dinamis berdasarkan jumlah tab
-- + simpan posisi/ukuran window terakhir
wezterm.on("update-status", function(window, pane)
	save_state(window, pane)

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
config.font_size = 18
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
	-- debug overlay (log error & Lua REPL), berguna untuk cek masalah config
	{ action = act.ShowDebugOverlay, mods = "CTRL|SHIFT", key = "L" },

	-- Buka tab baru mengikuti direktori pane aktif
	{ key = "T", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	-- close active tab
	-- { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	-- Cmd+W: close tab aktif (macOS)
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
	-- Cmd+Shift+W: modal pilih tab (fuzzy) lalu close
	{
		key = "W",
		mods = "CMD|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local choices = {}

			-- tabs_with_info() sudah memberi index tab (mulai 0) dan status aktif
			for _, info in ipairs(window:mux_window():tabs_with_info()) do
				local mux_tab = info.tab
				-- sama persis dengan judul di tab bar: nama folder dari cwd pane aktif
				local title = dir_name_from_cwd(mux_tab:active_pane():get_current_working_dir())
				if info.is_active then
					title = "  " .. title
				else
					title = "  " .. title
				end
				table.insert(choices, {
					id = tostring(mux_tab:tab_id()),
					label = string.format("%d:%s%s", info.index + 1, title, info.is_active and "  (aktif)" or ""),
				})
			end

			window:perform_action(
				act.InputSelector({
					title = "Close tab",
					description = "Pilih tab yang akan ditutup. Enter: pilih, Esc: batal",
					fuzzy_description = "Cari tab: ",
					choices = choices,
					fuzzy = true,
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						-- Escape / batal
						if not id then
							return
						end

						local target_tab = wezterm.mux.get_tab(tonumber(id))
						if not target_tab then
							return
						end

						-- MuxTab tidak punya method close(): aktifkan tab, lalu tutup via action
						target_tab:activate()
						inner_window:perform_action(act.CloseCurrentTab({ confirm = true }), target_tab:active_pane())
					end),
				}),
				pane
			)
		end),
	},
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
