local gtable = Gears.table
local textbox = Wibox.widget.textbox
local beautiful = require("beautiful")
local setmetatable = setmetatable
local escape_text = Helpers.text.escape_text
local tostring = tostring
local ipairs = ipairs
local string = string
local capi = {
	awesome = awesome
}

local text = {
	mt = {}
}

local properties = {
	"bold", "italic",
	"color", "on_color", "underline_color", "strikethrough_color",
	"text_transform", "line_height", "underline", "strikethrough",
	"scale", "size", "text", "icon", "font"
}

local function extract_size(input_string)
	-- Encuentra el último grupo de dígitos en la cadena
	local last_numbers = input_string:match("(%d+)%s*$")
	return last_numbers
end

local function remove_size(font)
	-- return string.gsub(font, extract_size(font) or "", "") .. " "
	local size = extract_size(font)
	if size then
		return string.gsub(font, size, "")
	end
	return font
end

local function generate_markup(self, color)
	local wp = self._private

	local bold_start = ""
	local bold_end = ""
	local italic_start = ""
	local italic_end = ""

	if wp.bold == true then
		bold_start = "<b>"
		bold_end = "</b>"
	end
	if wp.italic == true then
		italic_start = "<i>"
		italic_end = "</i>"
	end

	color = color or wp.color or wp.defaults.color
	local underline = wp.underline or wp.defaults.underline
	local underline_color = wp.underline_color or wp.defaults.underline_color
	local strikethrough = wp.strikethrough or wp.defaults.strikethrough
	local strikethrough_color = wp.strikethrough_color or wp.defaults.strikethrough_color
	local text_transform = wp.text_transform or wp.defaults.text_transform
	local line_height = wp.line_height or wp.defaults.line_height
	local _text = wp.text or wp.defaults.text

	_text = escape_text(tostring(_text))
	-- Need to unescape in a case the text was escaped by other code before
	-- _text = gstring.xml_unescape(tostring(_text))
	-- _text = gstring.xml_escape(_text)

	self.markup = string.format(
		"<span foreground='%s' underline='%s' underline_color='%s' strikethrough='%s' strikethrough_color='%s' text_transform='%s' line_height='%s'>%s%s%s%s%s</span>",
		color,
		underline,
		underline_color,
		strikethrough,
		strikethrough_color,
		text_transform,
		line_height,
		bold_start,
		italic_start,
		_text,
		italic_end,
		bold_end
	)
end

local function build_properties(prototype, prop_names)
	for _, prop in ipairs(prop_names) do
		if not prototype["set_" .. prop] then
			prototype["set_" .. prop] = function(self, value)
				if self._private[prop] ~= value then
					self._private[prop] = value
					if prop ~= "size" then -- Not necessary
						generate_markup(self)
					end
					self:emit_signal("widget::redraw_needed")
					self:emit_signal("property::" .. prop, value)
				end
				return self
			end
		end
		if not prototype["get_" .. prop] then
			prototype["get_" .. prop] = function(self)
				return self._private[prop]
			end
		end
	end
end

function text:get_type()
	return "text"
end

function text:update_display_color(color)
	generate_markup(self, color)
end

function text:get_font()
	return self._private.font or self._private.defaults.font
end

function text:set_size(size)
	local wp = self._private
	-- Remove the previous size from the font field
	local font = remove_size(wp.font or "")
	rawset(wp, "size", size)
	rawset(wp.defaults, "size", size)
	self:set_font(font)
end

function text:set_font(font)
	font = font .. " "
	local wp = self._private
	-- rawset(wp, "size",  or wp.size or wp.defaults.size)
	local size = extract_size(font)
	if size then
		wp.size = size
		wp.defaults.size = size
	else
		font = font .. tostring(wp.size or wp.defaults.size)
	end
	wp.font = font

	wp.layout:set_font_description(beautiful.get_font(font))
	self:emit_signal("widget::redraw_needed")
	self:emit_signal("widget::layout_changed")
	self:emit_signal("property::font", font)
end

local function new()
	local widget = textbox()
	gtable.crush(widget, text, true)

	local wp = widget._private

	-- Setup default values
	wp.defaults = {}
	wp.defaults.font = beautiful.font_reg_s
	wp.defaults.size = extract_size(wp.defaults.font)
	wp.defaults.color = beautiful.fg_normal
	wp.defaults.underline = "none"
	wp.defaults.underline_color = wp.defaults.color
	wp.defaults.strikethrough = false
	wp.defaults.strikethrough_color = wp.defaults.color
	wp.defaults.text_transform = "none"
	wp.defaults.line_height = 0
	wp.defaults.text = ""


	-- if not wp.font then
	-- widget:set_font(wp.defaults.font)
	-- end

	-- widget:connect_signal("property::font", function (_, font)
	-- 	wp.size = extract_size(font)
	-- end)

	generate_markup(widget)

	return widget
end

function text.mt:__call(...)
	return new(...)
end

build_properties(text, properties)

return setmetatable(text, text.mt)
