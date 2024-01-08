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

local function page_backward(self, direction)
	if self._private.current_page > 1 then
		self._private.current_page = self._private.current_page - 1
	elseif self.wrap_page_scrolling and #self._private.matched_entries >= self._private.max_apps_per_page then
		self._private.current_page = self._private.pages_count
	elseif self.wrap_app_scrolling then
		local rows, columns = self._private.grid:get_dimension()
		unselect_app(self)
		select_app(self, math.min(rows, #self._private.grid.children % self.apps_per_row), columns)
		return
	else
		return
	end

	local pos = self._private.grid:get_widget_position(self._private.active_widget)

	-- Remove the current page apps from the grid
	self._private.grid:reset()

	local max_app_index_to_include = self._private.apps_per_page * self._private.current_page
	local min_app_index_to_include = max_app_index_to_include - self._private.apps_per_page

	for index, entry in pairs(self._private.matched_entries) do
		-- Only add widgets that are between this range (part of the current page)
		if index > min_app_index_to_include and index <= max_app_index_to_include then
			self._private.grid:add(create_app_widget(self, entry))
		end
	end

	local rows, columns = self._private.grid:get_dimension()
	if self._private.current_page < self._private.pages_count then
		if direction == "up" then
			select_app(self, rows, columns)
		else
			-- Keep the same row from last page
			select_app(self, pos.row, columns)
		end
	elseif self.wrap_page_scrolling then
		if direction == "up" then
			select_app(self, math.min(rows, #self._private.grid.children % self.apps_per_row), columns)
		else
			-- Keep the same row from last page
			select_app(self, math.min(pos.row, #self._private.grid.children % self.apps_per_row), columns)
		end
	end
end

local function page_forward(self, direction)
	local min_app_index_to_include = 0
	local max_app_index_to_include = self._private.apps_per_page

	if self._private.current_page < self._private.pages_count then
		min_app_index_to_include = self._private.apps_per_page * self._private.current_page
		self._private.current_page = self._private.current_page + 1
		max_app_index_to_include = self._private.apps_per_page * self._private.current_page
	elseif self.wrap_page_scrolling and #self._private.matched_entries >= self._private.max_apps_per_page then
		self._private.current_page = 1
		min_app_index_to_include = 0
		max_app_index_to_include = self._private.apps_per_page
	elseif self.wrap_app_scrolling then
		unselect_app(self)
		select_app(self, 1, 1)
		return
	else
		return
	end

	local pos = self._private.grid:get_widget_position(self._private.active_widget)

	-- Remove the current page apps from the grid
	self._private.grid:reset()

	for index, entry in pairs(self._private.matched_entries) do
		-- Only add widgets that are between this range (part of the current page)
		if index > min_app_index_to_include and index <= max_app_index_to_include then
			self._private.grid:add(create_app_widget(self, entry))
		end
	end

	if self._private.current_page > 1 or self.wrap_page_scrolling then
		if direction == "down" then
			select_app(self, 1, 1)
		else
			local last_col_max_row = math.min(pos.row, #self._private.grid.children % self.apps_per_row)
			if last_col_max_row ~= 0 then
				select_app(self, last_col_max_row, 1)
			else
				select_app(self, pos.row, 1)
			end
		end
	end
end

local function scroll_up(self)
	if #self._private.grid.children < 1 then
		self._private.active_widget = nil
		return
	end

	local rows, columns = self._private.grid:get_dimension()
	local pos = self._private.grid:get_widget_position(self._private.active_widget)
	local is_bigger_than_first_app = pos.col > 1 or pos.row > 1

	-- Check if the current marked app is not the first
	if is_bigger_than_first_app then
		unselect_app(self)
		if pos.row == 1 then
			select_app(self, rows, pos.col - 1)
		else
			select_app(self, pos.row - 1, pos.col)
		end
	else
		page_backward(self, "up")
	end
end

local function scroll_down(self)
	if #self._private.grid.children < 1 then
		self._private.active_widget = nil
		return
	end

	local rows, columns = self._private.grid:get_dimension()
	local pos = self._private.grid:get_widget_position(self._private.active_widget)
	local is_less_than_max_app = self._private.grid:index(self._private.active_widget) < #self._private.grid.children

	-- Check if we can scroll down the app list
	if is_less_than_max_app then
		-- Unmark the previous app
		unselect_app(self)
		if pos.row == rows then
			select_app(self, 1, pos.col + 1)
		else
			select_app(self, pos.row + 1, pos.col)
		end
	else
		page_forward(self, "down")
	end
end

local function scroll_left(self)
	if #self._private.grid.children < 1 then
		self._private.active_widget = nil
		return
	end

	local pos = self._private.grid:get_widget_position(self._private.active_widget)
	local is_bigger_than_first_column = pos.col > 1

	-- Check if the current marked app is not the first
	if is_bigger_than_first_column then
		unselect_app(self)
		select_app(self, pos.row, pos.col - 1)
	else
		page_backward(self, "left")
	end
end

local function scroll_right(self)
	if #self._private.grid.children < 1 then
		self._private.active_widget = nil
		return
	end

	local rows, columns = self._private.grid:get_dimension()
	local pos = self._private.grid:get_widget_position(self._private.active_widget)
	local is_less_than_max_column = pos.col < columns

	-- Check if we can scroll down the app list
	if is_less_than_max_column then
		-- Unmark the previous app
		unselect_app(self)

		-- Scroll up to the max app if there are directly to the right of previous app
		if self._private.grid:get_widgets_at(pos.row, pos.col + 1) == nil then
			local app = self._private.grid.children[#self._private.grid.children]
			pos = self._private.grid:get_widget_position(app)
			select_app(self, pos.row, pos.col)
		else
			select_app(self, pos.row, pos.col + 1)
		end
	else
		page_forward(self, "right")
	end
end

local function reset(self)
	self._private.grid:reset()
	self._private.matched_entries = self._private.all_entries
	self._private.apps_per_page = self._private.max_apps_per_page
	self._private.pages_count = math.ceil(#self._private.all_entries / self._private.apps_per_page)
	self._private.current_page = 1

	for index, entry in pairs(self._private.all_entries) do
		-- Only add the apps that are part of the first page
		if index <= self._private.apps_per_page then
			self._private.grid:add(create_app_widget(self, entry))
		else
			break
		end
	end

	select_app(self, 1, 1)
end


