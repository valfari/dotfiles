local wezterm = require("wezterm")
local home = os.getenv("HOME")
local fonts = require("fonts")
local act = wezterm.action

wezterm.add_to_config_reload_watch_list(home .. "/.cache/wal/wezterm-wal.toml")

-- Tab title: process icon + cwd basename
local process_icons = {
	fish = "󰈺",
	zsh = "",
	bash = "",
	nvim = "",
	vim = "",
	git = "",
	ssh = "󰣀",
	htop = "",
	btm = "",
	lazygit = "",
}

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local pane = tab.active_pane
	local proc = pane.foreground_process_name:match("([^/]+)$") or ""
	local icon = process_icons[proc] or "󰆍"
	local cwd = pane.current_working_dir
	local dir = cwd and cwd.file_path:match("([^/]+)$") or "~"

	-- Tokyo Night Storm palette
	local active_bg = "#3d59a1"
	local active_fg = "#c0caf5"
	local inactive_bg = "#1f2335"
	local inactive_fg = "#565f89"
	local hover_bg = "#2d3f76"

	local bg = tab.is_active and active_bg or (hover and hover_bg or inactive_bg)
	local fg = tab.is_active and active_fg or inactive_fg

	local title = string.format(" %s  %s ", icon, wezterm.truncate_right(dir, max_width - 6))

	return {
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },
	}
end)

return {
	adjust_window_size_when_changing_font_size = false,
	font = wezterm.font_with_fallback(fonts.getFonts("fira")),
	-- Copy & Paste Right Click

	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				local has_selection = window:get_selection_text_for_pane(pane) ~= ""
				if has_selection then
					window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
					window:perform_action(act.ClearSelection, pane)
				else
					window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
				end
			end),
		},
	},
	-- OpenGL for GPU acceleration, Software for CPU
	front_end = "OpenGL",
	color_scheme_dirs = { home .. "/.cache/wal" },
	color_scheme = "Tokyo Night Storm",

	-- Font config
	warn_about_missing_glyphs = false,
	font_size = 12,
	line_height = 1.0,
	dpi = 96.0,

	-- Cursor style
	default_cursor_style = "BlinkingBar",

	-- X11
	-- enable_wayland = true,

	-- Keybinds
	disable_default_key_bindings = true,
	keys = {
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "0", mods = "CTRL", action = "ResetFontSize" },
		{
			key = "R",
			--r for right
			mods = "CTRL|SHIFT",
			action = wezterm.action({
				SplitHorizontal = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "D",
			-- d for down
			mods = "CTRL|SHIFT",
			action = wezterm.action({
				SplitVertical = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Left" }),
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Right" }),
		},
		{
			key = "UpArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Up" }),
		},
		{
			key = "DownArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Down" }),
		},
		{
			key = "LeftArrow",
			mods = "CTRL",
			action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }),
		},
		{
			key = "RightArrow",
			mods = "CTRL",
			action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }),
		},
		{
			key = "UpArrow",
			mods = "CTRL",
			action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }),
		},
		{
			key = "DownArrow",
			mods = "CTRL",
			action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }),
		},

		{
			key = "X",
			mods = "CTRL",
			action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
		},
		{ -- browser-like bindings for tabbing
			key = "t",
			mods = "CTRL",
			action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
		},
		{
			key = "W",
			mods = "CTRL",
			action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
		},
		{
			key = "Tab",
			mods = "CTRL",
			action = wezterm.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "Tab",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivateTabRelative = -1 }),
		}, -- standard copy/paste bindings
		{ key = "c", mods = "CMD", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },
		{ key = "v", mods = "CMD", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	},

	-- Aesthetic Night Colorscheme
	bold_brightens_ansi_colors = true,
	-- Padding
	window_padding = {
		left = 25,
		right = 25,
		top = 25,
		bottom = 25,
	},
	-- enable_kitty_graphics = true,

	-- Tab Bar
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	tab_max_width = 32,
	colors = {
		tab_bar = {
			background = "#1f2335",
			new_tab = { bg_color = "#1f2335", fg_color = "#565f89" },
			new_tab_hover = { bg_color = "#2d3f76", fg_color = "#c0caf5" },
		},
	},
	-- General
	window_decorations = "TITLE | RESIZE",
	automatically_reload_config = true,
	inactive_pane_hsb = { saturation = 0.5, brightness = 0.5 },
	window_close_confirmation = "NeverPrompt",
	-- window_frame = { active_titlebar_bg = "#45475a", font = font_with_fallback(font_name, { bold = true }) },
}
