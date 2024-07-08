-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------
local text = { mt = {} }

local function generate_markup(self)
   local bold_start = ""
   local bold_end = ""
   local italic_start = ""
   local italic_end = ""
   local spacing = ""

   if self._private.bold == true then
      bold_start = "<b>"
      bold_end = "</b>"
   end
   if self._private.italic == true then
      italic_start = "<i>"
      italic_end = "</i>"
   end
   if self._private.letter_spacing then
      spacing = "letter_spacing='" .. tostring(self._private.letter_spacing) .. "' "
   end
   self._private.text = Helpers.text.escape_text(self._private.text)
   self.markup = "<span "
       .. spacing
       .. ">"
       .. bold_start
       .. italic_start
       .. Helpers.text.colorize_text(self._private.text, self._private.color)
       .. italic_end
       .. bold_end
       .. "</span>"
end

function text:set_halign(halign)
   self.align = halign
end

function text:set_font(font)
   self._private.font = font
   self:emit_signal("widget::redraw_needed")
   self:emit_signal("widget::layout_changed")
   self:emit_signal("property::font", font)
end

function text:set_bold(bold)
   self._private.bold = bold
   generate_markup(self)
end

function text:set_italic(italic)
   self._private.italic = italic
   generate_markup(self)
end

function text:set_width(width)
   self.forced_width = width
end

function text:set_height(height)
   self.forced_height = height
end

function text:set_size(size)
   -- Remove the previous size from the font field
   local font = string.gsub(self._private.font, self._private.size, "")
   self._private.size = size
   self:set_font(font .. size)
end

function text:set_color(color)
   self._private.color = color
   generate_markup(self)
end

function text:set_text(_text)
   self._private.text = _text
   generate_markup(self)
end

local function new(args)
   args = args or {}

   args.width = args.width or nil
   args.height = args.height or nil
   args.halign = args.halign or nil
   args.valign = args.valign or nil
   args.font = args.font ~= nil and args.font .. " " or Beautiful.font_name or nil
   args.bold = args.bold ~= nil and args.bold or false
   args.italic = args.italic ~= nil and args.italic or false
   args.size = args.size or (args.no_size and "" or 11)
   args.color = args.color or Beautiful.fg_normal
   args.text = args.text ~= nil and args.text or ""
   args.id = args.id or "text_role"
   args.wrap = args.wrap or nil
   args.ellipsize = args.ellipsize or nil

   local widget = Wibox.widget({
      widget = Wibox.widget.textbox,
      forced_width = args.width,
      forced_height = args.height,
      halign = args.halign,
      align = args.halign,
      valign = args.valign,
      id = args.id,
      wrap = args.wrap,
      font = args.font and args.font .. args.size or Beautiful.font,
   })

   Gears.table.crush(widget, text, true)

   widget._private.font = args.font
   widget._private.bold = args.bold
   widget._private.italic = args.italic
   widget._private.size = args.size
   widget._private.color = args.color
   widget._private.text = args.text
   widget._private.letter_spacing = args.letter_spacing or nil

   generate_markup(widget)
   return widget
end

function text.mt:__call(...)
   return new(...)
end

return setmetatable(text, text.mt)
