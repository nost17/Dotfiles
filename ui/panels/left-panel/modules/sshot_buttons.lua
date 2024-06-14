local template = require((...):match("(.-)[^%.]+$") .. "controls.modules.base")
local dpi = Beautiful.xresources.apply_dpi
local delay_count = 0
local icons = {
  crop = Beautiful.icons .. "others/sshot_region.svg",
  full = Beautiful.icons .. "others/sshot_full.svg",
  check = Beautiful.icons .. "others/circle.svg",
  checked = Beautiful.icons .. "others/circle_checked.svg",
  up = Beautiful.icons .. "others/arrow_up.svg",
  down = Beautiful.icons .. "others/arrow_down.svg",
}

local function alert(title)
  Naughty.notification({
    title = title,
  })
end

local button_region = template.only_icon({
  icon = icons.crop,
  padding = Beautiful.widget_padding.outer,
  on_press = function()
    awesome.emit_signal("widgets::quicksettings", "hide")
    Utils.screenshot:notify(Utils.screenshot.select())
  end,
})
local button_full = template.only_icon({
  icon = icons.full,
  padding = Beautiful.widget_padding.outer,
  on_press = function()
    awesome.emit_signal("widgets::quicksettings", "hide")
    Utils.screenshot:notify(Utils.screenshot.normal())
  end,
})
local button_hide_cursor = template.with_label({
  icon_off = icons.check,
  icon_on = icons.checked,
  -- padding = {
  --   right = Beautiful.widget_padding.outer,
  --   left = 0,
  --   top = Beautiful.widget_padding.outer,
  --   bottom = Beautiful.widget_padding.outer,
  -- },
  label = "cursor",
  fn_on = function()
    alert("oculto")
  end,
  fn_off = function()
    alert("mostrar")
  end,
})

local delay_text = Wibox.widget({
  widget = Wibox.widget.textbox,
  text = delay_count,
  valign = "center",
  halign = "center",
})

local button_up = template.only_icon({
  icon = icons.up,
  border_width = 0,
  padding = 0,
  on_press = function()
    delay_count = delay_count + 1
    delay_text:set_text(delay_count)
  end,
})
local button_down = template.only_icon({
  icon = icons.down,
  border_width = 0,
  padding = 0,
  on_press = function()
    if delay_count > 0 then
      delay_count = delay_count - 1
      delay_text:set_text(delay_count)
    end
  end,
})

local button_delay = Wibox.widget({
  widget = Wibox.container.background,
  shape = Helpers.shape.rrect(Beautiful.radius),
  bg = Beautiful.widget_border.color,
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = Beautiful.widget_border.width,
    button_up,
    {
      widget = Wibox.container.background,
      bg = Beautiful.neutral[850],
      delay_text,
    },
    button_down,
  },
})

return Wibox.widget({
  widget = Wibox.container.margin,
  top = Beautiful.widget_spacing,
  visible = false,
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = Beautiful.widget_spacing,
    -- fill_space = true,
    button_hide_cursor,
    button_delay,
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = Beautiful.widget_spacing,
      button_region,
      button_full,
    },
  },
})
