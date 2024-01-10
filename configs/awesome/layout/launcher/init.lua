local Gio = require("lgi").Gio
local Gtk = require("lgi").require("Gtk", "3.0")
local getIcon = require("utils.modules.get_icon")
local prompt = require("layout.launcher.prompt")
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

local function get_gicon_path(gicon)
	if gicon == nil then
		return false
	end

	local icon_info = Gtk.IconTheme.get_default():lookup_by_gicon(gicon, 48, 0)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end
	return false
end

local function string_levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0

	-- quick cut-offs to save time
	if len1 == 0 then
		return len2
	elseif len2 == 0 then
		return len1
	elseif str1 == str2 then
		return 0
	end

	-- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end

	-- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if str1:byte(i) == str2:byte(j) then
				cost = 0
			else
				cost = 1
			end

			matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
		end
	end

	-- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

local function case_insensitive_pattern(pattern)
	-- find an optional '%' (group 1) followed by any character (group 2)
	local p = pattern:gsub("(%%?)(.)", function(percent, letter)
		if percent ~= "" or not letter:match("%a") then
			-- if the '%' matched, or `letter` is not a letter, return "as is"
			return percent .. letter
		else
			-- else, return a case-insensitive character class of the matched letter
			return string.format("[%s%s]", letter:lower(), letter:upper())
		end
	end)

	return p
end

local function has_value(tab, val)
	for index, value in pairs(tab) do
		if val:find(case_insensitive_pattern(value)) then
			return true
		end
	end
	return false
end

local function select_app(self, x, y)
	local widgets = self._private.grid:get_widgets_at(x, y)
	if widgets then
		self._private.active_widget = widgets[1]
		if self._private.active_widget ~= nil then
			self._private.active_widget.selected = true
			Helpers.gc(self._private.active_widget, "background").bg = self.app_selected_color
			local name_widget = Helpers.gc(self._private.active_widget, "name")
			if name_widget then
				name_widget.markup = Helpers.text.colorize_text(name_widget.text, self.app_name_selected_color)
			end
		end
	end
end

local function unselect_app(self)
	if self._private.active_widget ~= nil then
		self._private.active_widget.selected = false
		Helpers.gc(self._private.active_widget, "background").bg = self.app_normal_color
		local name_widget = Helpers.gc(self._private.active_widget, "name")
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
						name,
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
			Helpers.gc(w_app, "background").bg = self.app_selected_hover_color
		else
			Helpers.gc(w_app, "background").bg = self.app_normal_hover_color
		end
	end)

	app:connect_signal("mouse::leave", function(_self)
		local widget = capi.mouse.current_wibox
		if widget then
			widget.cursor = "left_ptr"
		end

		local w_app = _self
		if w_app.selected then
			Helpers.gc(w_app, "background").bg = self.app_selected_color
		else
			Helpers.gc(w_app, "background").bg = self.app_normal_color
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

local function search(self, text)
	unselect_app(self)

	local pos = self._private.grid:get_widget_position(self._private.active_widget)

	-- Reset all the matched entries
	self._private.matched_entries = {}
	-- Remove all the grid widgets
	self._private.grid:reset()

	if text == "" then
		self._private.matched_entries = self._private.all_entries
	else
		for index, entry in pairs(self._private.all_entries) do
			text = text:gsub("%W", "")

			-- Check if there's a match by the app name or app command
			if
				string.find(entry.name:lower(), text:lower(), 1, true) ~= nil
				or self.search_commands and string.find(entry.commandline, text:lower(), 1, true) ~= nil
			then
				table.insert(self._private.matched_entries, {
					name = entry.name,
					generic_name = entry.generic_name,
					commandline = entry.commandline,
					executable = entry.executable,
					terminal = entry.terminal,
					icon = entry.icon,
				})
			end
		end

		-- Sort by string similarity
		table.sort(self._private.matched_entries, function(a, b)
			return string_levenshtein(text, a.name) < string_levenshtein(text, b.name)
		end)
	end
	for index, entry in pairs(self._private.matched_entries) do
		-- Only add the widgets for apps that are part of the first page
		if #self._private.grid.children + 1 <= self._private.max_apps_per_page then
			self._private.grid:add(create_app_widget(self, entry))
		end
	end

	-- Recalculate the apps per page based on the current matched entries
	self._private.apps_per_page = math.min(#self._private.matched_entries, self._private.max_apps_per_page)

	-- Recalculate the pages count based on the current apps per page
	self._private.pages_count =
		math.ceil(math.max(1, #self._private.matched_entries) / math.max(1, self._private.apps_per_page))

	-- Page should be 1 after a search
	self._private.current_page = 1

	-- This is an option to mimic rofi behaviour where after a search
	-- it will reselect the app whose index is the same as the app index that was previously selected
	-- and if matched_entries.length < current_index it will instead select the app with the greatest index
	if self.try_to_keep_index_after_searching then
		if self._private.grid:get_widgets_at(pos.row, pos.col) == nil then
			local app = self._private.grid.children[#self._private.grid.children]
			pos = self._private.grid:get_widget_position(app)
		end
		select_app(self, pos.row, pos.col)
	-- Otherwise select the first app on the list
	else
		select_app(self, 1, 1)
	end
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
	if columns == 1 then
		select_app(self, rows, 1)
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
		-- return
		page_forward(self, "down")
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

local function generate_apps(self)
	self._private.all_entries = {}
	self._private.matched_entries = {}

	local app_info = Gio.AppInfo
	local apps = app_info.get_all()
	if self.sort_alphabetically then
		table.sort(apps, function(a, b)
			local app_a_score = app_info.get_name(a):lower()
			if has_value(self.favorites, app_info.get_name(a)) then
				app_a_score = "aaaaaaaaaaa" .. app_a_score
			end
			local app_b_score = app_info.get_name(b):lower()
			if has_value(self.favorites, app_info.get_name(b)) then
				app_b_score = "aaaaaaaaaaa" .. app_b_score
			end

			return app_a_score < app_b_score
		end)
	else
		table.sort(apps, function(a, b)
			local app_a_favorite = has_value(self.favorites, app_info.get_name(a))
			local app_b_favorite = has_value(self.favorites, app_info.get_name(b))

			if app_a_favorite and not app_b_favorite then
				return true
			elseif app_b_favorite and not app_a_favorite then
				return false
			elseif app_a_favorite and app_b_favorite then
				return app_info.get_name(a):lower() < app_info.get_name(b):lower()
			else
				return false
			end
		end)
	end

	-- local icon_theme = require(tostring(path):match(".*bling") .. ".helpers.icon_theme")(self.icon_theme, self.icon_size)

	for _, app in ipairs(apps) do
		if app.should_show(app) then
			local name = app_info.get_name(app)
			local commandline = app_info.get_commandline(app)
			local executable = app_info.get_executable(app)
			local icon = get_gicon_path(app_info.get_icon(app))

			-- Check if this app should be skipped, depanding on the skip_names / skip_commands table
			if not has_value(self.skip_names, name) and not has_value(self.skip_commands, commandline) then
				-- Check if this app should be skipped becuase it's iconless depanding on skip_empty_icons
				if icon ~= "" or self.skip_empty_icons == false then
					if icon == "" or not icon then
						if self.default_app_icon_name ~= nil then
							icon = getIcon({
								name = self.default_app_icon_name,
							})
						elseif self.default_app_icon_path ~= nil then
							icon = self.default_app_icon_path
						end
					end
					local desktop_app_info = Gio.DesktopAppInfo.new(app_info.get_id(app))
					local terminal = Gio.DesktopAppInfo.get_string(desktop_app_info, "Terminal") == "true" and true
						or false
					table.insert(self._private.all_entries, {
						name = name,
						commandline = commandline,
						executable = executable,
						terminal = terminal,
						icon = icon,
					})
				end
			end
		end
	end
end

--- Shows the app launcher
function app_launcher:show()
	local screen = self.screen
	if self.show_on_focused_screen then
		screen = Awful.screen.focused()
	end

	screen.app_launcher = self._private.widget
	screen.app_launcher.screen = screen
	self._private.prompt:start()

	screen.app_launcher.visible = true

	awesome.emit_signal("visible::app_launcher", true)
end

--- Hides the app launcher
function app_launcher:hide()
	local screen = self.screen
	if self.show_on_focused_screen then
		screen = Awful.screen.focused()
	end

	if screen.app_launcher == nil or screen.app_launcher.visible == false then
		return
	end

	self._private.prompt:stop()

	if self.reset_on_hide == true then
		reset(self)
	end
	screen.app_launcher.visible = false
	screen.app_launcher = nil

	awesome.emit_signal("visible::app_launcher", false)
end

function app_launcher:toggle()
	local screen = self.screen
	if self.show_on_focused_screen then
		screen = Awful.screen.focused()
	end

	if screen.app_launcher and screen.app_launcher.visible then
		self:hide()
	else
		self:show()
	end
end

local function create_user_button(icon, color, shape, fn)
	local wdg = require("utils.button.text").normal({
		text = icon,
		font = Beautiful.font_icon .. "15",
		shape = shape,
		fg_normal = color,
		bg_normal = color .. "1F",
		bg_hover = color .. "3F",
		on_release = fn,
		forced_height = Dpi(46),
	})
	return wdg
end

local function new(args)
	args = args or {}

	args.terminal = args.terminal or nil
	args.favorites = args.favorites or {}
	args.search_commands = args.search_commands == nil and true or args.search_commands
	args.skip_names = args.skip_names or {}
	args.skip_commands = args.skip_commands or {}
	args.skip_empty_icons = args.skip_empty_icons ~= nil and args.skip_empty_icons or false
	args.sort_alphabetically = args.sort_alphabetically == nil and true or args.sort_alphabetically
	args.reverse_sort_alphabetically = args.reverse_sort_alphabetically ~= nil and args.reverse_sort_alphabetically
		or false
	args.select_before_spawn = args.select_before_spawn == nil and true or args.select_before_spawn
	args.hide_on_left_clicked_outside = args.hide_on_left_clicked_outside == nil and true
		or args.hide_on_left_clicked_outside
	args.hide_on_right_clicked_outside = args.hide_on_right_clicked_outside == nil and true
		or args.hide_on_right_clicked_outside
	args.hide_on_launch = args.hide_on_launch == nil and true or args.hide_on_launch
	args.try_to_keep_index_after_searching = args.try_to_keep_index_after_searching ~= nil
			and args.try_to_keep_index_after_searching
		or false
	args.reset_on_hide = args.reset_on_hide == nil and true or args.reset_on_hide
	args.save_history = args.save_history == nil and true or args.save_history
	args.wrap_page_scrolling = args.wrap_page_scrolling == nil and true or args.wrap_page_scrolling
	args.wrap_app_scrolling = args.wrap_app_scrolling == nil and true or args.wrap_app_scrolling

	args.default_app_icon_name = args.default_app_icon_name or nil
	args.default_app_icon_path = args.default_app_icon_path or nil
	args.icon_theme = args.icon_theme or nil
	args.icon_size = args.icon_size or nil

	args.type = args.type or "dock"
	args.show_on_focused_screen = args.show_on_focused_screen == nil and true or args.show_on_focused_screen
	args.screen = args.screen or capi.screen.primary
	args.placement = args.placement or Awful.placement.centered
	args.rubato = args.rubato or nil
	args.shrink_width = args.shrink_width ~= nil and args.shrink_width or false
	args.shrink_height = args.shrink_height ~= nil and args.shrink_height or false
	args.background = args.background or "#000000"
	args.border_width = args.border_width or Beautiful.border_width or Dpi(0)
	args.border_color = args.border_color or Beautiful.border_color or "#FFFFFF"
	args.shape = args.shape or nil

	args.prompt_image_bg_ratio = args.prompt_image_bg_ratio or 0
	args.prompt_image_bg_height = args.prompt_image_bg_height or Dpi(120)

	args.prompt_height = args.prompt_height or Dpi(100)
	args.prompt_margins = args.prompt_margins or Dpi(0)
	args.prompt_paddings = args.prompt_paddings or Dpi(30)
	args.prompt_shape = args.prompt_shape or nil
	args.prompt_color = args.prompt_color or Beautiful.fg_normal or "#FFFFFF"
	args.prompt_border_width = args.prompt_border_width or Beautiful.border_width or Dpi(0)
	args.prompt_border_color = args.prompt_border_color or Beautiful.border_color or args.prompt_color
	args.prompt_text_halign = args.prompt_text_halign or "left"
	args.prompt_text_valign = args.prompt_text_valign or "center"
	args.prompt_icon_text_spacing = args.prompt_icon_text_spacing or Dpi(10)
	args.prompt_show_icon = args.prompt_show_icon == nil and true or args.prompt_show_icon
	args.prompt_icon_font = args.prompt_icon_font or Beautiful.font
	args.prompt_icon_color = args.prompt_icon_color or Beautiful.bg_normal or "#000000"
	args.prompt_icon = args.prompt_icon or ""
	args.prompt_icon_markup = args.prompt_icon_markup
		or string.format("<span size='xx-large' foreground='%s'>%s</span>", args.prompt_icon_color, args.prompt_icon)
	args.prompt_text = args.prompt_text or "<b>Search</b>: "
	args.prompt_start_text = args.prompt_start_text or ""
	args.prompt_font = args.prompt_font or Beautiful.font
	args.prompt_text_color = args.prompt_text_color or Beautiful.bg_normal or "#000000"
	args.prompt_cursor_color = args.prompt_cursor_color or Beautiful.bg_normal or "#000000"

	args.apps_per_row = args.apps_per_row or 5
	args.apps_per_column = args.apps_per_column or 3
	args.apps_margin = args.apps_margin or Dpi(30)
	args.apps_spacing = args.apps_spacing or Dpi(30)

	args.expand_apps = args.expand_apps == nil and true or args.expand_apps
	args.app_width = args.app_width or Dpi(300)
	args.app_height = args.app_height or Dpi(32)
	args.app_shape = args.app_shape or nil
	args.app_normal_color = args.app_normal_color or Beautiful.bg_normal or "#000000"
	args.app_normal_hover_color = args.app_normal_hover_color or nil
	args.app_selected_color = args.app_selected_color or Beautiful.fg_normal or "#FFFFFF"
	args.app_selected_hover_color = args.app_selected_hover_color or nil
	args.app_content_padding = args.app_content_padding or 0
	args.app_content_spacing = args.app_content_spacing or Dpi(10)
	args.app_show_icon = args.app_show_icon == nil and true or args.app_show_icon
	args.app_icon_halign = args.app_icon_halign or "center"
	args.app_icon_width = args.app_icon_width or Dpi(48)
	args.app_icon_height = args.app_icon_height or Dpi(48)
	args.app_show_name = args.app_show_name == nil and true or args.app_show_name
	args.app_name_generic_name_spacing = args.app_name_generic_name_spacing or Dpi(0)
	args.app_name_halign = args.app_name_halign or "center"
	args.app_name_font = args.app_name_font or Beautiful.font
	args.app_name_normal_color = args.app_name_normal_color or Beautiful.fg_normal or "#FFFFFF"
	args.app_name_selected_color = args.app_name_selected_color or Beautiful.bg_normal or "#000000"
	args.app_show_generic_name = args.app_show_generic_name ~= nil and args.app_show_generic_name or false

	local ret = Gears.object({})
	ret._private = {}
	ret._private.text = ""

	Gears.table.crush(ret, app_launcher)
	Gears.table.crush(ret, args)

	-- Calculate the grid width and height
	local grid_width = ret.shrink_width == false
			and Dpi((ret.app_width * ret.apps_per_column) + ((ret.apps_per_column - 1) * ret.apps_spacing))
		or nil
	local grid_height = ret.shrink_height == false
			and Dpi((ret.app_height * ret.apps_per_row) + ((ret.apps_per_row - 1) * ret.apps_spacing))
		or nil

	-- These widgets need to be later accessed
	ret._private.prompt = prompt({
		prompt = ret.prompt_text,
		text = ret.prompt_start_text,
		font = ret.prompt_font,
		reset_on_stop = ret.reset_on_hide,
		bg_cursor = ret.prompt_cursor_color,
		history_path = ret.save_history == true and Gears.filesystem.get_cache_dir() .. "/history" or nil,
		changed_callback = function(text)
			if text == ret._private.text then
				return
			end

			if ret._private.search_timer ~= nil and ret._private.search_timer.started then
				ret._private.search_timer:stop()
			end

			ret._private.search_timer = Gears.timer({
				timeout = 0.05,
				autostart = true,
				single_shot = true,
				callback = function()
					search(ret, text)
				end,
			})

			ret._private.text = text
		end,
		keypressed_callback = function(mod, key, cmd)
			if key == "Escape" then
				ret:hide()
			end
			if key == "Return" then
				if ret._private.active_widget ~= nil then
					ret._private.active_widget.spawn()
				end
			end
			if key == "Up" then
				scroll_up(ret)
			end
			if key == "Down" then
				scroll_down(ret)
			end
			if key == "Left" then
				scroll_left(ret)
			end
			if key == "Right" then
				scroll_right(ret)
			end
		end,
	})
	ret._private.grid = Wibox.widget({
		layout = Wibox.layout.grid,
		forced_width = grid_width,
		forced_height = grid_height,
		orientation = "horizontal",
		homogeneous = true,
		expand = ret.expand_apps,
		spacing = ret.apps_spacing,
		forced_num_rows = ret.apps_per_row,
		buttons = {
			Awful.button({}, 4, function()
				scroll_up(ret)
			end),
			Awful.button({}, 5, function()
				scroll_down(ret)
			end),
		},
	})
	-- 󰌾 󰐥 󰒲
	local sleep_button = create_user_button(
		"󰒲",
		Beautiful.yellow,
		Helpers.shape.rrect(Beautiful.small_radius),
		function()
			Awful.spawn("systemctl suspend", false)
		end
	)
	local lockscreen_button = create_user_button(
		"󰌾",
		Beautiful.blue,
		Helpers.shape.rrect(Beautiful.small_radius),
		function()
			Awful.spawn("kitty", false)
		end
	)
	local logout_button = create_user_button(
		"󰍃",
		Beautiful.green,
		Helpers.shape.rrect(Beautiful.small_radius),
		function()
			Awful.spawn("kitty", false)
		end
	)
	ret._private.widget = Awful.popup({
		type = args.type,
		visible = false,
		ontop = true,
		placement = ret.placement,
		border_width = ret.border_width,
		border_color = ret.border_color,
		shape = ret.shape,
		bg = ret.background,
		widget = {
			layout = Wibox.layout.fixed.horizontal,
			{
				widget = Wibox.container.background,
				bg = args.border_color,
				forced_width = Dpi(50) + args.border_width + args.grid_margins * 1.5,
				{
					widget = Wibox.container.margin,
					margins = {
            top = args.grid_margins or 0,
            bottom = args.grid_margins or 0,
            right = args.grid_margins,
            left = args.grid_margins - args.border_width,
          },
					{
						layout = Wibox.layout.align.vertical,
						nil,
						nil,
						{
							layout = Wibox.layout.fixed.vertical,
              spacing = args.grid_margins,
							sleep_button,
							lockscreen_button,
							logout_button,
						},
					},
				},
			},
			{
				widget = Wibox.container.margin,
				margins = args.grid_margins or 0,
				{
					layout = Wibox.layout.fixed.vertical,
					spacing = args.grid_spacing or 0,
					{
						layout = Wibox.layout.stack,
						{
							image = Helpers.cropSurface(
								args.prompt_image_bg_ratio,
								Gears.surface.load_uncached(Beautiful.wallpaper)
							),
							halign = "center",
							valign = "center",
							resize = true,
							vertical_fit_policy = "fill",
							horizontal_fit_policy = "fill",
							clip_shape = args.prompt_image_bg_shape or nil,
							forced_width = grid_width,
							forced_height = args.prompt_image_bg_height,
							widget = Wibox.widget.imagebox,
						},
						{
							widget = Wibox.container.margin,
							margins = ret.prompt_margins,
							{
								layout = Wibox.layout.align.vertical,
								expand = "outside",
								nil,
								{
									widget = Wibox.container.background,
									forced_height = ret.prompt_height,
									shape = ret.prompt_shape,
									bg = ret.prompt_color,
									fg = ret.prompt_text_color,
									border_width = ret.prompt_border_width,
									border_color = ret.prompt_border_color,
									{
										widget = Wibox.container.margin,
										margins = ret.prompt_paddings,
										{
											widget = Wibox.container.place,
											halign = ret.prompt_text_halign,
											valign = ret.prompt_text_valign,
											{
												layout = Wibox.layout.fixed.horizontal,
												spacing = ret.prompt_icon_text_spacing,
												{
													widget = Wibox.widget.textbox,
													font = ret.prompt_icon_font,
													markup = ret.prompt_icon_markup,
												},
												ret._private.prompt.textbox,
											},
										},
									},
								},
							},
						},
					},
					{
						widget = Wibox.container.margin,
						margins = ret.apps_margin,
						ret._private.grid,
					},
				},
			},
		},
	})

	-- Private variables to be used to be used by the scrolling and searching functions
	ret._private.max_apps_per_page = ret.apps_per_column * ret.apps_per_row
	ret._private.apps_per_page = ret._private.max_apps_per_page
	ret._private.pages_count = 0
	ret._private.current_page = 1

	generate_apps(ret)
	reset(ret)

	if ret.hide_on_left_clicked_outside then
		Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function(c)
			ret:hide()
		end))

		Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function(c)
			ret:hide()
		end))
	end
	if ret.hide_on_right_clicked_outside then
		Awful.mouse.append_client_mousebinding(Awful.button({}, 3, function(c)
			ret:hide()
		end))

		Awful.mouse.append_global_mousebinding(Awful.button({}, 3, function(c)
			ret:hide()
		end))
	end

	local kill_old_inotify_process_script =
		[[ ps x | grep "inotifywait -e modify /usr/share/applications" | grep -v grep | awk '{print $1}' | xargs kill ]]
	local subscribe_script = [[ bash -c "while (inotifywait -e modify /usr/share/applications -qq) do echo; done" ]]

	Awful.spawn.easy_async_with_shell(kill_old_inotify_process_script, function()
		Awful.spawn.with_line_callback(subscribe_script, {
			stdout = function(_)
				generate_apps(ret)
			end,
		})
	end)

	return ret
end

function app_launcher.mt:__call(...)
	return new(...)
end
setmetatable(app_launcher, app_launcher.mt)

local props = require("layout.launcher.props")
local my_launcher = app_launcher(props)

awesome.connect_signal("awesome::app_launcher", function(action)
	if action == "toggle" then
		my_launcher:toggle()
	elseif action == "open" then
		my_launcher:show()
	elseif action == "close" then
		my_launcher:hide()
	end
end)
