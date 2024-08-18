local wtext = Utils.widgets.text
local wbutton = Utils.widgets.button
local gobject = Gears.object
local gtable = Gears.table
local dpi = Beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local os = os

local get_current_month = function(time)
  return Helpers.text.first_upper(tostring(os.date("%B %Y", time)))
end

--- Calendar Widget
--- ~~~~~~~~~~~~~~~

local calendar = { mt = {} }

local style = {
  border_color = Beautiful.widget_border.color,
  border_width = Beautiful.widget_border.width,
  shape = Helpers.shape.rrect(Beautiful.radius),
  header = {
    bg_normal = Beautiful.neutral[800],
    bg_hover = Beautiful.neutral[700],
    fg_normal = Beautiful.fg_normal,
  },
  days = {
    font = Beautiful.font_reg_s,
    font_selected = Beautiful.font_bold_s,
    fg_normal = Beautiful.neutral[200] .. "ED",
    fg_other = Beautiful.neutral[100] .. "55",
    bg_normal = Beautiful.neutral[850],
    fg_selected = Beautiful.neutral[900],
    bg_selected = Beautiful.primary[500],
    height = dpi(32),
    width = dpi(38),
  },
  weak_days = {
    -- color = Beautiful.primary[500],
    color = Beautiful.neutral[200],
    accent = Beautiful.primary[400],
    size = dpi(38),
  },
}

style.weak_days.bg_normal = style.border_width ~= 0 and style.header.bg_normal

local function day_name_widget(name, weekend)
  return Wibox.widget({
    widget = Wibox.container.background,
    -- forced_width = style.weak_days.size,
    -- forced_height = style.weak_days.size,
    bg = style.weak_days.bg_normal,
    Wibox.widget({
      widget = Wibox.widget.textbox,
      halign = "center",
      font = Beautiful.font_reg_s,
      markup = Helpers.text.generate_markup({
        color = weekend and style.weak_days.accent or style.weak_days.color,
        bold = true,
        text = name,
      })
    }),
  })
end

local function date_widget(date, is_current, is_another_month)
  local text_color = style.days.fg_normal
  if is_current == true then
    text_color = style.days.fg_selected
  elseif is_another_month == true then
    text_color = style.days.fg_other
  end

  return Wibox.widget({
    widget = Wibox.container.constraint,
    {
      widget = Wibox.container.background,
      forced_width = style.days.width,
      forced_height = style.days.height,
      -- bg = style.days.bg_normal,
      fg = text_color,
      bg = is_current and style.days.bg_selected or style.days.bg_normal,
      border_width = 2,
      border_color = style.days.bg_normal,
      -- fg = text_color,
      shape = (style.border_width == 0 or is_current) and Gears.shape.circle,
      {
        text = tostring(date),
        halign = "center",
        valign = "center",
        font = is_current and style.days.font_selected or style.days.font,
        widget = Wibox.widget.textbox,
      },
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
  self.days:add(day_name_widget("Sa", true))
  self.days:add(day_name_widget("Do", true))

  local first_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 }))
  local last_day = os.date("*t", os.time({ year = date.year, month = date.month + 1, day = 0 }))
  local month_days = last_day.day

  local time = os.time({ year = date.year, month = date.month, day = 1 })
  self.month:set_text(get_current_month(time))

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

local function icon_button(icon, action)
  return Wibox.widget({
    widget = Wibox.container.constraint,
    strategy = "exact",
    width = style.days.width,
    {
      widget = wbutton.normal,
      padding = 0,
      halign = "center",
      color = style.header.bg_normal,
      normal_border_width = 0,
      on_release = action,
      {
        widget = Wibox.widget.textbox,
        markup = Helpers.text.colorize_text(icon, style.header.fg_normal),
        font = "Material Design Icons Desktop 16",
      }
    }
  })
end

local function new(...)
  local ret = gobject({})
  gtable.crush(ret, calendar, true)

  ret.month = Wibox.widget({
    widget = wbutton.normal,
    halign = "left",
    padding = Beautiful.widget_padding.inner,
    color = style.header.bg_normal,
    normal_border_width = 0,
    on_release = function()
      ret:set_date_current()
    end,
    {
      widget = Wibox.container.background,
      fg = style.header.fg_normal,
      {
        widget = Wibox.widget.textbox,
        text = get_current_month(),
        font = Beautiful.font_med_m,
      }
    }
  })
  function ret.month:set_text(text)
    self:get_content().children[1].text = text
  end

  -- TODO: Replace unicode icons with svg icons
  local month = Wibox.widget({
    layout = Wibox.layout.align.horizontal,
    nil,
    ret.month,
    {
      layout = Wibox.layout.flex.horizontal,
      icon_button("󰅃", function()
        ret:increase_date()
      end),
      icon_button("󰅀", function()
        ret:decrease_date()
      end)
    },
  })

  ret.days = Wibox.widget({
    layout = Wibox.layout.grid,
    row_count = 6,
    column_count = 7,
    spacing = 0,
    expand = true,
  })

  local widget = Wibox.widget({
    widget = Wibox.container.background,
    border_color = style.border_color,
    border_width = style.border_width,
    shape = style.border_width ~= 0 and style.shape,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = style.border_width == 0 and dpi(8) or 0,
      -- spacing = Beautiful.widget_spacing,
      {
        widget = Wibox.container.background,
        forced_height = style.days.width,
        shape = style.border_width == 0 and style.shape,
        month,
      },
      {
        widget = Wibox.container.background,
        bg = style.border_color,
        forced_height = style.border_width,
      },
      {
        widget = Wibox.container.background,
        -- bg = style.border_width ~= 0 and style.border_color,
        bg = style.days.bg_normal,
        shape = style.border_width == 0 and style.shape,
        {
          widget = Wibox.container.margin,
          ret.days,
        },
      },
    },
  })

  ret:set_date(os.date("*t"))

  gtable.crush(widget, calendar, true)
  return widget
end

function calendar.mt:__call(...)
  return new(...)
end

return setmetatable(calendar, calendar.mt)
