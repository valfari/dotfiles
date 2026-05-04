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
-- accent_colors: active tab bar highlight; bg_tints: terminal background for all panes in the tab
local accent_colors = {
	"#2c4172", -- blue (default)
	"#4d7a34", -- green
	"#7a5e2e", -- orange
	"#7a3344", -- red
	"#5a4280", -- purple
	"#2e6680", -- cyan
}
local bg_tints = {
	"#24283b", -- default Tokyo Night Storm bg
	"#1e2b1e", -- green
	"#2b2218", -- orange
	"#2b1e1e", -- red
	"#1e1b2b", -- purple
	"#1b2b2b", -- cyan
}
local tab_colors = {}

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local pane = tab.active_pane
	local proc = pane.foreground_process_name:match("([^/]+)$") or ""
	local icon = process_icons[proc] or "󰆍"
	local cwd = pane.current_working_dir
	local dir = cwd and cwd.file_path:match("([^/]+)$") or "~"

	-- Tokyo Night Storm palette
	local tab_bar_bg = "#1f2335"
	local active_bg = accent_colors[tab_colors[tab.tab_id] or 1]
	local active_fg = "#c0caf5"
	local inactive_bg = "#24283b"
	local inactive_fg = "#565f89"
	local hover_bg = "#2d3f76"

	local bg = tab.is_active and active_bg or (hover and hover_bg or inactive_bg)
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
	window:set_config_overrides({
		colors = {
			background = bg_tints[idx],
			tab_bar = {
				background = "#1f2335",
				new_tab = { bg_color = "#1f2335", fg_color = "#565f89" },
				new_tab_hover = { bg_color = "#2d3f76", fg_color = "#c0caf5" },
			},
		},
	})
end

wezterm.on("update-right-status", function(window, pane)
	-- Apply per-tab background tint to all panes in the active tab
	local id = window:active_tab():tab_id()
	apply_tab_color(window, tab_colors[id] or 1)

	local cwd_uri = pane:get_current_working_dir()
	local branch = ""
	if cwd_uri then
		local ok, stdout, _ = wezterm.run_child_process({
			"git",
			"-C",
			cwd_uri.file_path,
			"rev-parse",
			"--abbrev-ref",
			"HEAD",
		})
		if ok then
			branch = "  " .. stdout:gsub("%s+$", "") .. "  "
		end
	end

	local time = wezterm.strftime(" %H:%M ")

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#7aa2f7" } },
		{ Text = branch },
		{ Foreground = { Color = "#565f89" } },
		{ Text = time },
	}))
end)

wezterm.on("cycle-tab-color-next", function(window, _)
	local id = window:active_tab():tab_id()
	local idx = (tab_colors[id] or 1) % #accent_colors + 1
	tab_colors[id] = idx
	apply_tab_color(window, idx)
end)

wezterm.on("cycle-tab-color-prev", function(window, _)
	local id = window:active_tab():tab_id()
	local idx = ((tab_colors[id] or 1) - 2) % #accent_colors + 1
	tab_colors[id] = idx
	apply_tab_color(window, idx)
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
	tab_max_width = 64,
	colors = {
		tab_bar = {
			background = "#1f2335",
			new_tab = { bg_color = "#1f2335", fg_color = "#565f89" },
			new_tab_hover = { bg_color = "#2d3f76", fg_color = "#c0caf5" },
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
