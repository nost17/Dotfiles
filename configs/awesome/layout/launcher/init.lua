local Gio = require("lgi").Gio
local getIcon = require("utils.modules.get_icon")
local string = string
local table = table
local math = math
local ipairs = ipairs
local pairs = pairs
local capi = { screen = screen, mouse = mouse }

local app_launcher = { mt = {} }

local terminal_commands_lookup = {
	alacritty = "alacritty -e",
	termite = "termite -e",
	rxvt = "rxvt -e",
	terminator = "terminator -e",
	kitty = "kitty -e",
}

local function select_app(self, x, y)
	local widgets = self._private.grid:get_widgets_at(x, y)
	if widgets then
		self._private.active_widget = widgets[1]
		if self._private.active_widget ~= nil then
			self._private.active_widget.selected = true
			self._private.active_widget:get_children_by_id("background")[1].bg = self.app_selected_color
			local name_widget = self._private.active_widget:get_children_by_id("name")[1]
			if name_widget then
				name_widget.markup = Helpers.text.colorize_text(name_widget.text, self.app_name_selected_color)
			end
		end
	end
end

local function unselect_app(self)
	if self._private.active_widget ~= nil then
		self._private.active_widget.selected = false
		self._private.active_widget:get_children_by_id("background")[1].bg = self.app_normal_color
		local name_widget = self._private.active_widget:get_children_by_id("name")[1]
		if name_widget then
			name_widget.markup = Helpers.text.colorize_text(name_widget.text, self.app_name_normal_color)
		end
		self._private.active_widget = nil
	end
end

local function create_app_widget(self, entry)
	local icon = self.app_show_icon == true
			and {
				widget = Wibox.widget.imagebox,
				halign = "center",
				forced_width = self.app_icon_width,
				forced_height = self.app_icon_height,
				image = entry.icon,
			}
		or nil

	local name = self.app_show_name == true
			and {
				widget = Wibox.widget.textbox,
				id = "name",
				font = self.app_name_font,
				markup = Helpers.text.colorize_text(entry.name, self.app_name_normal_color),
			}
		or nil

	local app = Wibox.widget({
		widget = Wibox.container.background,
		id = "background",
		forced_width = self.app_width,
		forced_height = self.app_height,
		shape = self.app_shape,
		bg = self.app_normal_color,
		{
			widget = Wibox.container.margin,
			margins = self.app_content_padding,
			{
				-- Using this hack instead of container.place because that will fuck with the name/icon halign
				layout = Wibox.layout.align.vertical,
				expand = "outside",
				nil,
				{
					layout = Wibox.layout.fixed.horizontal,
					spacing = self.app_content_spacing,
					icon,
					{
						widget = Wibox.container.place,
						halign = self.app_name_halign,
						{
							layout = Wibox.layout.fixed.horizontal,
							spacing = self.app_name_generic_name_spacing,
							name,
						},
					},
				},
				nil,
			},
		},
	})

	function app.spawn()
		if entry.terminal == true then
			if self.terminal ~= nil then
				local terminal_command = terminal_commands_lookup[self.terminal] or self.terminal
				Awful.spawn(terminal_command .. " " .. entry.executable)
			else
				Awful.spawn.easy_async("gtk-launch " .. entry.executable, function(stdout, stderr)
					if stderr then
						Awful.spawn(entry.executable)
					end
				end)
			end
		else
			Awful.spawn(entry.executable)
		end

		if self.hide_on_launch then
			self:hide()
		end
	end

	app:connect_signal("mouse::enter", function(_self)
		local widget = capi.mouse.current_wibox
		if widget then
			widget.cursor = "hand2"
		end

		local w_app = _self
		if w_app.selected then
			w_app:get_children_by_id("background")[1].bg = self.app_selected_hover_color
		else
			app:get_children_by_id("background")[1].bg = self.app_normal_hover_color
		end
	end)

	app:connect_signal("mouse::leave", function(_self)
		local widget = capi.mouse.current_wibox
		if widget then
			widget.cursor = "left_ptr"
		end

		local w_app = _self
		if w_app.selected then
			w_app:get_children_by_id("background")[1].bg = self.app_selected_color
		else
			w_app:get_children_by_id("background")[1].bg = self.app_normal_color
		end
	end)

	app:connect_signal("button::press", function(_self, _, _, button, _, _)
		if button == 1 then
			local w_app = _self
			if self._private.active_widget == w_app or not self.select_before_spawn then
				w_app.spawn()
			else
				-- Unmark the previous app
				unselect_app(self)

				-- Mark this app
				local pos = self._private.grid:get_widget_position(w_app)
				select_app(self, pos.row, pos.col)
			end
		end
	end)

	return app
end
