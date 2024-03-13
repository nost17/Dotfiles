local screenshot_lib = require("utils.modules.screenshot")
local wbutton = require("utils.button")
local dpi = Beautiful.xresources.apply_dpi
local delay_count = 0
local hide_cursor = false

local function button(icon, fn, size)
  return wbutton.text.normal({
    text = icon,
    font = Beautiful.font_icon,
    size = size or 14,
    bg_normal = Beautiful.quicksettings_ctrl_btn_bg,
    paddings = {
      left = dpi(10),
      right = dpi(10),
    },
    on_release = fn or function()
      Naughty.notification({
        title = "holis",
      })
    end,
  })
end
local function screenshot_notify(ss)
  local open_image = Naughty.action({ name = "Abrir imagen." })
  ss:connect_signal("file::saved", function(self, file_name, file_path)
    open_image:connect_signal("invoked", function()
      Awful.spawn.with_shell("feh " .. file_path .. file_name)
    end)
    Naughty.notify({
      message = file_name,
      title = "Captura guardada.",
      image = file_path .. file_name,
      actions = { open_image },
    })
  end)
end

-- 󰄀 󰄄 󰄅 󰆞 󰔛 󰅀
-- 󰏝 󰄴

local delay_label = Wibox.widget({
  widget = Wibox.widget.textbox,
  text = delay_count,
  font = Beautiful.font_text .. "Regular 10",
  halign = "center",
  valign = "center",
})

local screenshot_normal = button("󰔂", function()
  awesome.emit_signal("panels::quicksettings", "hide")
  local ss = screenshot_lib.normal({
    hide_cursor = hide_cursor,
    delay = delay_count,
  })
  screenshot_notify(ss)
end)

local screenshot_selective = button("󰆞", function()
  awesome.emit_signal("panels::quicksettings", "hide")
  local ss = screenshot_lib.select({
    hide_cursor = hide_cursor,
    delay = delay_count,
  })
  screenshot_notify(ss)
end)

local screenshot_settings = Wibox.widget({
  layout = Wibox.layout.flex.horizontal,
  forced_height = dpi(42),
  {
    widget = Wibox.container.background,
    wbutton.elevated.state({
      bg_normal_on = Beautiful.quicksettings_ctrl_btn_bg,
      on_by_default = hide_cursor,
      paddings = { left = dpi(10), right = dpi(10) },
      halign = "left",
      child = {
        layout = Wibox.layout.fixed.horizontal,
        spacing = dpi(6),
        {
          widget = Wibox.widget.textbox,
          text = hide_cursor and "󰄴" or "󰏝",
          font = Beautiful.font_icon .. "13",
          id = "hide_cursor_icon",
          halign = "center",
          valign = "center",
        },
        {
          widget = Wibox.widget.textbox,
          text = "Ocultar cursor",
          font = Beautiful.font_text .. "Regular 11",
          halign = "center",
          valign = "center",
        },
      },
      on_turn_on = function(self)
        hide_cursor = true
        Helpers.gc(self, "hide_cursor_icon").text = "󰄴"
      end,
      on_turn_off = function(self)
        hide_cursor = false
        Helpers.gc(self, "hide_cursor_icon").text = "󰏝"
      end,
    }),
  },
  {
    layout = Wibox.layout.flex.horizontal,
    button("󰍝", function()
      if delay_count > 0 then
        delay_count = delay_count - 1
        delay_label:set_text(delay_count)
      end
    end),
    delay_label,
    button("󰍠", function()
      delay_count = delay_count + 1
      delay_label:set_text(delay_count)
    end),
  },
})

local screenshot = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.quicksettings_ctrl_btn_bg,
  shape = Beautiful.quicksettings_ctrl_btn_shape,
  {
    layout = Wibox.layout.flex.vertical,
    {
      layout = Wibox.layout.flex.horizontal,
      forced_height = dpi(42),
      screenshot_normal,
      screenshot_selective,
    },
    screenshot_settings,
  },
})

awesome.connect_signal("visible::quicksettings:sc", function(vis)
  if vis then
    delay_count = 0
    delay_label:set_text(delay_count)
  end
end)

return screenshot
