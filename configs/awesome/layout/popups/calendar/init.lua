local wtext = require("utils.modules.text")
local wbutton = require("utils.button")
local gobject = Gears.object
local gtable = Gears.table
local dpi = Beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local os = os

--- Calendar Widget
--- ~~~~~~~~~~~~~~~

local calendar = { mt = {} }

local style = {
  header = {
    bg_normal = Beautiful.widget_bg,
    bg_hover = Beautiful.widget_bg_alt,
    fg_normal = Beautiful.fg_normal,
  },
  days = {
    font = Beautiful.font_text .. "Medium 11",
    fg_normal = Beautiful.fg_normal .. "DD",
    fg_other = Beautiful.fg_normal .. "44",
  },
}

local function day_name_widget(name)
  return Wibox.widget({
    widget = Wibox.container.background,
    forced_width = dpi(34),
    forced_height = dpi(34),
    wtext({
      halign = "center",
      color = Beautiful.accent_color,
      size = 11,
      bold = true,
      text = name,
    }),
  })
end

local function date_widget(date, is_current, is_another_month)
  local text_color = style.days.fg_normal
  if is_current == true then
    text_color = Beautiful.foreground_alt
  elseif is_another_month == true then
    text_color = style.days.fg_other
  end

  return Wibox.widget({
    widget = Wibox.container.background,
    forced_width = dpi(34),
    forced_height = dpi(34),
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    bg = is_current and Beautiful.accent_color,
    fg = text_color,
    {
      text = tostring(date),
      halign = "center",
      valign = "center",
      font = style.days.font,
      widget = Wibox.widget.textbox,
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
    font = Beautiful.font_text .. "Medium",
    halign = "left",
    bg_normal = style.header.bg_normal,
    bg_hover = style.header.bg_hover,
    fg_normal = style.header.fg_normal,
    on_release = function()
      ret:set_date_current()
    end,
  })

  local month = Wibox.widget({
    layout = Wibox.layout.align.horizontal,
    nil,
    ret.month,
    {
      layout = Wibox.layout.flex.horizontal,
      wbutton.text.normal({
        text = "󰅃",
        font = Beautiful.font_icon,
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
        font = Beautiful.font_icon,
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

  ret.days = Wibox.widget({
    layout = Wibox.layout.grid,
    forced_num_rows = 6,
    forced_num_cols = 7,
    spacing = dpi(8),
    expand = true,
  })

  local widget = Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    -- spacing = dpi(0),
    month,
    ret.days,
  })

  ret:set_date(os.date("*t"))

  gtable.crush(widget, calendar, true)
  return widget
end

local main = new()

local clock = Wibox.widget({
  widget = Wibox.container.margin,
  -- left = 10,
  -- right = 10,
  {
    layout = Wibox.layout.fixed.vertical,
    {
      widget = Wibox.widget.textclock,
      format = "%H:%M:%S",
      refresh = 1,
      font = Beautiful.font_text .. "Regular 30",
      halign = "left",
    },
    {
      widget = Wibox.container.background,
      fg = Beautiful.fg_normal .. "CC",
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
  -- minimum_width = 400,
  maximum_width = 400,
  placement = function(d)
    Awful.placement.bottom_left(d, {
      honor_workarea = true,
      margins = Beautiful.useless_gap * 2 + Beautiful.border_width * 2,
    })
  end,
  widget = {
    widget = Wibox.container.margin,
    margins = dpi(10),
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(10),
      {
        widget = Wibox.container.background,
        bg = Beautiful.widget_bg_alt,
        {
          widget = Wibox.container.margin,
          bottom = dpi(10),
          left = dpi(10),
          right = dpi(10),
          clock,
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
