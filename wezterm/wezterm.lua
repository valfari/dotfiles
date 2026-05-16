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

-- Tab colors (cycled per-tab with PageUp/PageDown)
-- Each entry is a full theme: color scheme + tab bar palette + accent color
local themes = {
	{
		scheme = "GruvboxDark",
		accent = "#504945",
		tab_bar_bg = "#282828",
		hover_bg = "#3c3836",
		active_fg = "#ebdbb2",
		inactive_fg = "#928374",
		branch_fg = "#fabd2f",
		time_fg = "#928374",
	},
	{
		scheme = "Everforest Dark (Gogh)",
		accent = "#4a5e44",
		tab_bar_bg = "#2d353b",
		hover_bg = "#3d4f47",
		active_fg = "#d3c6aa",
		inactive_fg = "#7a8478",
		branch_fg = "#a7c080",
		time_fg = "#7a8478",
	},
	{
		scheme = "Catppuccin Frappe",
		accent = "#414559",
		tab_bar_bg = "#303446",
		hover_bg = "#51576d",
		active_fg = "#c6d0f5",
		inactive_fg = "#737994",
		branch_fg = "#8caaee",
		time_fg = "#737994",
	},
	{
		scheme = "Tokyo Night Storm",
		accent = "#2e4379",
		tab_bar_bg = "#1f2335",
		hover_bg = "#2d3f76",
		active_fg = "#c0caf5",
		inactive_fg = "#565f89",
		branch_fg = "#7aa2f7",
		time_fg = "#565f89",
	},
	{
		scheme = "Kanagawa (Gogh)",
		accent = "#2d4f67",
		tab_bar_bg = "#1f1f28",
		hover_bg = "#2d4f67",
		active_fg = "#dcd7ba",
		inactive_fg = "#727169",
		branch_fg = "#7e9cd8",
		time_fg = "#727169",
	},
}
local tab_colors = {}
local last_applied = {} -- [win_id] = idx last passed to apply_tab_color

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local pane = tab.active_pane
	local proc = pane.foreground_process_name:match("([^/]+)$") or ""
	local icon = process_icons[proc] or "󰆍"
	local cwd = pane.current_working_dir
	local dir = cwd and cwd.file_path:match("([^/]+)$") or "~"

	local theme = themes[tab_colors[tab.tab_id] or 1]
	local tab_bar_bg = theme.tab_bar_bg
	local active_fg = theme.active_fg
	local inactive_fg = theme.inactive_fg
	local hover_bg = theme.hover_bg

	local bg = hover and hover_bg or theme.accent
	local fg = tab.is_active and active_fg or inactive_fg

	local idx = tab.tab_index + 1
	local title = string.format(" %d: %s  %s ", idx, icon, wezterm.truncate_right(dir, max_width - 8))

	return {
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },
		-- powerline right arrow
		{ Background = { Color = tab_bar_bg } },
		{ Foreground = { Color = bg } },
		{ Text = "" },
	}
end)

local function apply_tab_color(window, idx)
	local t = themes[idx]
	window:set_config_overrides({
		color_scheme = t.scheme,
		colors = {
			tab_bar = {
				background = t.tab_bar_bg,
				new_tab = { bg_color = t.tab_bar_bg, fg_color = t.inactive_fg },
				new_tab_hover = { bg_color = t.hover_bg, fg_color = t.active_fg },
			},
		},
	})
end

wezterm.on("update-right-status", function(window, _)
	local id = window:active_tab():tab_id()
	local idx = tab_colors[id] or 1
	local win_id = window:window_id()
	if last_applied[win_id] ~= idx then
		apply_tab_color(window, idx)
		last_applied[win_id] = idx
	end
	window:set_right_status("")
end)

wezterm.on("cycle-tab-color-next", function(window, _)
	local id = window:active_tab():tab_id()
	local idx = (tab_colors[id] or 1) % #themes + 1
	tab_colors[id] = idx
	apply_tab_color(window, idx)
end)

wezterm.on("cycle-tab-color-prev", function(window, _)
	local id = window:active_tab():tab_id()
	local idx = ((tab_colors[id] or 1) - 2) % #themes + 1
	tab_colors[id] = idx
	apply_tab_color(window, idx)
end)

return {
	adjust_window_size_when_changing_font_size = false,
	font = wezterm.font_with_fallback(fonts.getFonts("victor")),
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
	color_scheme = "GruvboxDark",

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
		-- jump to tab by index
		{ key = "1", mods = "CMD", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "CMD", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "CMD", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "CMD", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "CMD", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "CMD", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "CMD", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "CMD", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "CMD", action = wezterm.action({ ActivateTab = 8 }) },
		-- cycle active tab accent color
		{ key = "PageUp", mods = "NONE", action = wezterm.action.EmitEvent("cycle-tab-color-next") },
		{ key = "PageDown", mods = "NONE", action = wezterm.action.EmitEvent("cycle-tab-color-prev") },
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
	tab_bar_at_bottom = false,
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 85,
	colors = {
		tab_bar = {
			background = "#282828",
			new_tab = { bg_color = "#282828", fg_color = "#928374" },
			new_tab_hover = { bg_color = "#3c3836", fg_color = "#ebdbb2" },
		},
	},
	-- General
	window_decorations = "INTEGRATED_BUTTONS | RESIZE",
	macos_window_background_blur = 20,
	window_background_opacity = 0.92,
	automatically_reload_config = true,
	inactive_pane_hsb = { saturation = 0.5, brightness = 0.5 },
	window_close_confirmation = "NeverPrompt",
	-- window_frame = { active_titlebar_bg = "#45475a", font = font_with_fallback(font_name, { bold = true }) },
}
