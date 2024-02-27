local gobject = require("gears.object")
local gtable = require("gears.table")
local gshape = require("gears.shape")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("utils.helpers")
local wtext = require("utils.modules.text")
local wbutton = require("utils.button")
local dpi = beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local os = os

--- Calendar Widget
--- ~~~~~~~~~~~~~~~

local calendar = { mt = {} }

local style = {
  header = {
    bg_normal = beautiful.widget_bg,
    bg_hover = beautiful.widget_bg_alt,
    fg_normal = beautiful.fg_normal,
  },
  days = {
    font = beautiful.font_text .. "Medium 11",
    fg_normal = beautiful.fg_normal .. "DD",
    fg_other = beautiful.fg_normal .. "44",
  },
}

local function day_name_widget(name)
  return wibox.widget({
    widget = wibox.container.background,
    forced_width = dpi(30),
    forced_height = dpi(30),
    wtext({
      halign = "center",
      color = beautiful.accent_color,
      size = 11,
      bold = true,
      text = name,
    }),
  })
end

local function date_widget(date, is_current, is_another_month)
  local text_color = style.days.fg_normal
  if is_current == true then
    text_color = beautiful.foreground_alt
  elseif is_another_month == true then
    text_color = style.days.fg_other
  end

  return wibox.widget({
    widget = wibox.container.background,
    forced_width = dpi(30),
    forced_height = dpi(30),
    shape = helpers.shape.rrect(beautiful.small_radius),
    bg = is_current and beautiful.accent_color,
    fg = text_color,
    {
      text = tostring(date),
      halign = "center",
      valign = "center",
      font = style.days.font,
      widget = wibox.widget.textbox,
    },
  })
end

function calendar:set_date(date)
  self.date = date

  self.days:reset()

  local current_date = os.date("*t")

  self.days:add(day_name_widget("Lu"))
  self.days:add(day_name_widget("Ma"))
  self.days:add(day_name_widget("Mi"))
  self.days:add(day_name_widget("Ju"))
  self.days:add(day_name_widget("Vi"))
  self.days:add(day_name_widget("Sa"))
  self.days:add(day_name_widget("Do"))

  local first_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 }))
  local last_day = os.date("*t", os.time({ year = date.year, month = date.month + 1, day = 0 }))
  local month_days = last_day.day

  local time = os.time({ year = date.year, month = date.month, day = 1 })
  self.month:set_text(tostring(os.date("%B %Y", time)):gsub("^%l", string.upper))

  local days_to_add_at_month_start = first_day.wday - 2
  local days_to_add_at_month_end = 42 - last_day.day - days_to_add_at_month_start - 1

  local previous_month_last_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 })).day
  for day = previous_month_last_day - days_to_add_at_month_start, previous_month_last_day - 0, 1 do
    self.days:add(date_widget(day, false, true))
  end

  for day = 1, month_days do
    local is_current = day == current_date.day and date.month == current_date.month
    self.days:add(date_widget(day, is_current, false))
  end

  for day = 1, days_to_add_at_month_end do
    self.days:add(date_widget(day, false, true))
  end
end

function calendar:set_date_current()
  self:set_date(os.date("*t"))
end

function calendar:increase_date()
  local new_calendar_month = self.date.month + 1
  self:set_date({ year = self.date.year, month = new_calendar_month, day = self.date.day })
end

function calendar:decrease_date()
  local new_calendar_month = self.date.month - 1
  self:set_date({ year = self.date.year, month = new_calendar_month, day = self.date.day })
end

local function new()
  local ret = gobject({})
  gtable.crush(ret, calendar, true)

  ret.month = wbutton.text.normal({
    text = tostring(os.date("%B %Y")):gsub("^%l", string.upper),
    size = 13,
    font = beautiful.font_text .. "Medium",
    halign = "left",
    bg_normal = style.header.bg_normal,
    bg_hover = style.header.bg_hover,
    fg_normal = style.header.fg_normal,
    on_release = function()
      ret:set_date_current()
    end,
  })

  local month = wibox.widget({
    layout = wibox.layout.align.horizontal,
    nil,
    ret.month,
    {
      layout = wibox.layout.flex.horizontal,
      wbutton.text.normal({
        text = "󰅃",
        font = beautiful.font_icon,
        size = 18,
        bg_normal = style.header.bg_normal,
        bg_hover = style.header.bg_hover,
        fg_normal = style.header.fg_normal,
        on_release = function()
          ret:increase_date()
        end,
      }),
      wbutton.text.normal({
        text = "󰅀",
        font = beautiful.font_icon,
        size = 18,
        bg_normal = style.header.bg_normal,
        bg_hover = style.header.bg_hover,
        fg_normal = style.header.fg_normal,
        on_release = function()
          ret:decrease_date()
        end,
      }),
    },
  })

  ret.days = wibox.widget({
    layout = wibox.layout.grid,
    forced_num_rows = 6,
    forced_num_cols = 7,
    spacing = dpi(8),
    expand = true,
  })

  local widget = wibox.widget({
    layout = wibox.layout.fixed.vertical,
    -- spacing = dpi(0),
    month,
    ret.days,
  })

  ret:set_date(os.date("*t"))

  gtable.crush(widget, calendar, true)
  return widget
end

local main = new()

local clock = wibox.widget({
  widget = wibox.container.margin,
  left = 10,
  right = 10,
  {
    layout = wibox.layout.fixed.vertical,
    {
      widget = Wibox.widget.textclock,
      format = "%H:%M:%S",
      refresh = 1,
      font = Beautiful.font_text .. "Regular 30",
      halign = "left",
    },
    {
      widget = wibox.container.background,
      fg = beautiful.fg_normal .. "CC",
      {
        widget = Wibox.widget.textclock,
        format = "%A, %B %d, %Y",
        font = Beautiful.font_text .. "Regular 10",
        halign = "left",
      },
    },
  },
})

local calendar_widget = Awful.popup({
  visible = false,
  ontop = true,
  border_width = Beautiful.border_width,
  border_color = Beautiful.border_color_normal,
  minimum_height = 330,
  -- maximum_height = 500,
  minimum_width = 346,
  maximum_width = 500,
  placement = function(d)
    Awful.placement.bottom_left(d, {
      honor_workarea = true,
      margins = Beautiful.useless_gap * 4 + Beautiful.border_width * 2,
    })
  end,
  widget = {
    widget = wibox.container.margin,
    margins = dpi(10),
    {
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(10),
      clock,
      {
        widget = wibox.container.margin,
        top = dpi(4),
        {
          widget = wibox.container.background,
          forced_height = 3,
          bg = beautiful.fg_normal .. "AA",
        },
      },
      main,
    },
  },
})

-- summon functions --

awesome.connect_signal("open::calendar", function()
  -- calendar:set_date(os.date("*t"))
  calendar_widget.visible = not calendar_widget.visible
end)
