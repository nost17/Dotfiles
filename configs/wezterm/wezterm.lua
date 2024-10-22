-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

-- local current_palette = wezterm.color.get_builtin_schemes()["OneDark (base16)"]


config.color_schemes = {
	-- ["OneDark"] = current_palette, #717373
   ["OneDark"] = wezterm.color.get_builtin_schemes()["OneDark (base16)"],
	["Tomorrow"] = require("custom_themes.tomorrow_night"),
   ["Gruvbox material dark"] = require("custom_themes.gruvbox_material_dark"),
   ["Gruvbox material light"] = require("custom_themes.gruvbox_material_light")
}
config.color_scheme = "OneDark"

local current_palette = config.color_schemes[config.color_scheme]

current_palette.ansi[1] = wezterm.color.parse(current_palette.ansi[1])

config.force_reverse_video_cursor = true

config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
})
config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font({
			family = "JetBrainsMono Nerd Font",
			weight = "Bold",
		}),
	},
}
config.font_size = 11
config.bold_brightens_ansi_colors = true
-- config.freetype_load_flags = 'NO_HINTING'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.colors = {
	tab_bar = {
		background = current_palette.background,
		active_tab = {
			bg_color = current_palette.ansi[4],
			fg_color = current_palette.ansi[1],
			-- bg_color = current_palette.brights[1],
			-- fg_color = current_palette.ansi[4],
			intensity = "Bold",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			italic = true,
			-- intensity = "Bold",
			bg_color = current_palette.background,
			fg_color = current_palette.ansi[1]:lighten(0.15),
			-- bg_color = current_palette.ansi[1],
			-- fg_color = current_palette.ansi[1]:lighten(0.25),
		},
		inactive_tab_hover = {
			bg_color = current_palette.brights[1],
			fg_color = "#909090",
			italic = false,
		},
		new_tab = {
			bg_color = current_palette.background,
			fg_color = current_palette.ansi[3],
		},
		new_tab_hover = {
			bg_color = current_palette.brights[1],
			fg_color = current_palette.ansi[3],
		},
	},
}

local padding = 12
config.window_padding = {
	left = padding,
	right = padding,
	top = padding / 2,
	bottom = padding / 2,
}

config.inactive_pane_hsb = {
	saturation = 0.87,
	brightness = 0.8,
}

local act = wezterm.action

config.keys = {
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = '"',
		mods = "ALT|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "!",
		mods = "ALT|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = act.ToggleFullScreen,
	},
	{
		key = "f",
		mods = "ALT|SHIFT",
		action = act.TogglePaneZoomState,
	},
	{
		key = "LeftArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
			mode = "SwapWithActive",
		}),
	},
	{
		key = "r",
		mods = "ALT",
		action = act.PromptInputLine({
			description = "Ingresa un nuevo nombre a la pestaña",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "n", mods = "ALT", action = act.RotatePanes("Clockwise") },
}

for i = 1, 9 do
	-- CTRL+ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

config.tab_max_width = 24
local PL_RIGHT_ICON = wezterm.nerdfonts.ple_lower_left_triangle
local PL_LEFT_ICON = wezterm.nerdfonts.ple_upper_right_triangle
local NF_DOT = wezterm.nerdfonts.oct_dot_fill

local tab_style_powerline = function(tab, tabs)
	local title = tab_title(tab)
	local bg_normal = config.colors.tab_bar.background
	local bg_inactive = config.colors.tab_bar.inactive_tab.bg_color
	local bg_active = tab.is_active and config.colors.tab_bar.active_tab.bg_color or bg_inactive
	local fg_active = tab.is_active and config.colors.tab_bar.active_tab.fg_color
		or config.colors.tab_bar.inactive_tab.fg_color
	return {
		{ Foreground = { Color = bg_active } },
		{ Background = { Color = bg_normal } },
		{ Text = (tab.tab_index == 0) and "" or PL_LEFT_ICON },

		{ Foreground = { Color = fg_active } },
		{ Background = { Color = bg_active } },
		{ Text = " " .. wezterm.truncate_right(title, config.tab_max_width - 4) .. " " },
		-- { Text = " " .. title  .. " " },

		{ Foreground = { Color = bg_active } },
		{ Background = { Color = bg_normal } },
		{ Text = PL_RIGHT_ICON },

		{ Foreground = { Color = "red" } },
		{ Text = (tab.tab_index == #tabs - 1) and " " or "" },
	}
end

local tab_style_dot_simple = function(tab, tabs)
	local title = tab_title(tab)
	local fg_active = tab.is_active and current_palette.ansi[4] or config.colors.tab_bar.inactive_tab.fg_color
	local bg_normal = config.colors.tab_bar.background
	local fg_dot = config.colors.tab_bar.inactive_tab.fg_color
	return {
		{ Background = { Color = bg_normal } },
		{ Foreground = { Color = fg_dot } },
		{ Text = (tab.tab_index == 0) and "" or "" .. "•" .. "" },
		{ Foreground = { Color = fg_active } },
		{ Text = " " .. title .. " " },
	}
end

-- local accent = current_palette.ansi[3]
local tab_style_simple = function(tab, tabs)
	local title = tab_title(tab)
	local title_t = wezterm.truncate_right(title, config.tab_max_width - 4)
	local fg_dot = current_palette.brights[1]
	local bg_normal = config.colors.tab_bar.background
	local bg_active = tab.is_active and config.colors.tab_bar.active_tab.bg_color or bg_normal
	return {
		-- { Background = { Color = bg_normal } },
		-- { Text = (tab.tab_index == 0) and " " or "" },
		{ Background = { Color = bg_active } },
		{ Text = " " .. title_t .. " " },
		{ Foreground = { Color = fg_dot } },
		{ Background = { Color = bg_normal } },
		{ Text = " " },
	}
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cnfig, hover, max_width)
	return tab_style_dot_simple(tab, tabs)
end)

-- and finally, return the configuration to wezterm
return config
