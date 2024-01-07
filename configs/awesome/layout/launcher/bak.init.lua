local ipairs = ipairs
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gio = lgi.Gio
local iconTheme = Gtk.IconTheme.get_default()

local main = {}
main._private = {}

awesome.connect_signal("awesome::app_launcher", function(action)
	if action == "toggle" then
		main._private.widget.visible = not main._private.widget.visible
	elseif action == "open" then
		main._private.widget.visible = true
	elseif action == "close" then
		main._private.widget.visible = false
	end
end)

local prompt_text = require("utils.container")({
	child = Helpers.text.mktext({
		text = "Aplicaciones...",
		halign = "left",
		size = 12,
		font = Beautiful.font_text,
	}),
	bg = Beautiful.bg_normal,
	halign = "left",
	valign = "center",
	constraint_strategy = "exact",
	-- constraint_height = Dpi(60),
	margins = {
		top = Dpi(8),
		bottom = Dpi(8),
		right = Dpi(60),
		left = Dpi(60),
	},
	paddings = {
		top = Dpi(8),
		bottom = Dpi(8),
		right = Dpi(16),
		left = Dpi(14),
	},
	shape = Helpers.shape.rrect(Beautiful.small_radius),
})
local prompt = Wibox.widget({
	{
		image = Helpers.misc.cropSurface(3.3, Gears.surface.load_uncached(Beautiful.wallpaper)),
		opacity = 0.9,
		-- forced_height = Dpi(140),
		clip_shape = Helpers.shape.rrect(Beautiful.medium_radius),
		-- forced_width = Dpi(380),
		widget = Wibox.widget.imagebox,
	},
	{
		prompt_text,
		valign = "center",
		content_fill_horizontal = true,
		layout = Wibox.container.place,
	},
	layout = Wibox.layout.stack,
})

local function get_apps()
	local app_list_table = {}
	for _, entry in ipairs(Gio.AppInfo.get_all()) do
		if entry:should_show(entry) then
			local app_info = Gio.AppInfo
			local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
			local icon = entry:get_icon()
			-- local icon = iconTheme:get_gicon_path(app_info.get_icon(entry))
			local desktop_app_info = Gio.DesktopAppInfo.new(app_info.get_id(entry))
			local generic_name = Gio.DesktopAppInfo.get_string(desktop_app_info, "GenericName[es]")
				or Gio.DesktopAppInfo.get_string(desktop_app_info, "GenericName")
			local path
			if icon then
				path = icon:to_string()
				if not path:find("/") then
					local icon_info = iconTheme:lookup_icon(path, 48, 0)
					local p = icon_info and icon_info:get_filename()
					path = p
				end
			end
			table.insert(
				app_list_table,
				{ name = name, appinfo = entry, icon = path or "", gname = generic_name or "none" }
			)
		end
	end
	return app_list_table
end

local function gen_app_list(container)
	-- container:reset()
	local app_list_table = get_apps()
	for i, app in ipairs(app_list_table) do
		local widget = Wibox.widget({
			{
				text = app.name,
				font = Beautiful.font,
				halign = "left",
				widget = Wibox.widget.textbox,
			},
			bg = Beautiful.bg_normal,
			widget = Wibox.container.background,
		})
		container:add(widget)
	end
end


main._private.grid = Wibox.widget({
	homogeneous = false,
	expand = false,
	forced_num_cols = 1,
	spacing = 4,
	layout = Wibox.layout.grid,
})
gen_app_list(main._private.grid)

main._private.widget = Awful.popup({
	maximum_width = Dpi(450),
	shape = Helpers.shape.rrect(Beautiful.small_radius),
	maximum_height = Dpi(310),
	bg = Beautiful.yellow,
	ontop = true,
	visible = false,
	placement = function(c)
		Awful.placement.top_left(c, { honor_workarea = true, margins = Beautiful.useless_gap * 2 })
	end,
	widget = {
		{
			Helpers.ui.horizontal_pad(Dpi(50)),
			bg = Beautiful.green,
			widget = Wibox.container.background,
		},
		{
			{
				prompt,
				main._private.grid,
				Helpers.ui.vertical_pad(10),
				layout = Wibox.layout.align.vertical,
			},
			margins = Dpi(8),
			widget = Wibox.container.margin,
		},
		nil,
		layout = Wibox.layout.align.horizontal,
	},
	-- border_width = Dpi(2),
	-- border_color = Beautiful.widget_bg_alt
})
