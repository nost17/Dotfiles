local screenshot_lib = require("utils.modules.screenshot")
local wbutton = require("utils.button")
local button_template = require("layout.qs-panel.mods.controls.base")
local dpi = Beautiful.xresources.apply_dpi
local delay_count = 0
local hide_cursor = false
local screenshot = Gears.object({})
local new_bg =
    Helpers.color.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.quicksettings_ctrl_btn_bg)

local function button(icon, fn, size)
  return wbutton.text.normal({
    text = icon,
    font = Beautiful.font_icon,
    size = size or 14,
    bg_normal = new_bg,
    shape = Beautiful.quicksettings_ctrl_btn_shape,
    paddings = dpi(10),
    on_release = fn,
  })
end
local function screenshot_notify(ss)
  local open_image = Naughty.action({ name = "Abrir" })
  local delete_image = Naughty.action({ name = "Eliminar" })
  ss:connect_signal("file::saved", function(self, file_name, file_path)
    open_image:connect_signal("invoked", function()
      Awful.spawn.with_shell("feh " .. file_path .. file_name)
    end)
    delete_image:connect_signal("invoked", function()
      Awful.spawn.with_shell("rm " .. file_path .. file_name)
    end)
    Naughty.notify({
      message = file_name,
      title = "Captura guardada.",
      image = file_path .. file_name,
      actions = { open_image, delete_image },
    })
  end)
end

local screenshot_normal = button("󰆟", function()
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

local delay_label = Wibox.widget({
  widget = Wibox.widget.textbox,
  text = delay_count,
  font = Beautiful.font_text .. "Regular 10",
  halign = "center",
  valign = "center",
})

local screenshot_options = Wibox.widget({
  layout = Wibox.layout.flex.vertical,
  spacing = dpi(10),
  -- forced_height = dpi(42),
  {
    widget = Wibox.container.background,
    wbutton.elevated.state({
      bg_normal = new_bg,
      bg_normal_on = new_bg,
      on_by_default = hide_cursor,
      shape = Beautiful.quicksettings_ctrl_btn_shape,
      paddings = dpi(10),
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
    widget = Wibox.container.background,
    shape = Beautiful.quicksettings_ctrl_btn_shape,
    bg = new_bg,
    {
      layout = Wibox.layout.flex.horizontal,
      button("󰅀", function()
        if delay_count > 0 then
          delay_count = delay_count - 1
          delay_label:set_text(delay_count)
        end
      end, 15),
      delay_label,
      button("󰅃", function()
        delay_count = delay_count + 1
        delay_label:set_text(delay_count)
      end, 15),
    },
  },
})

screenshot.settings = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.quicksettings_widgets_bg,
  shape = Beautiful.quicksettings_ctrl_btn_shape,
  {
    widget = Wibox.container.margin,
    margins = dpi(10),
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = dpi(10),
      screenshot_options,
      {
        layout = Wibox.layout.flex.horizontal,
        spacing = dpi(10),
        screenshot_normal,
        screenshot_selective,
      },
    },
  },
})

screenshot.button = button_template({
  icon = "󰄅",
  name = "Captura de pantalla",
  halign = "center",
  on_fn = function()
    screenshot:emit_signal("visible::settings", true)
  end,
  off_fn = function()
    screenshot:emit_signal("visible::settings", false)
  end,
})

screenshot:connect_signal("visible::settings", function(_, vis)
  if vis then
    delay_count = 0
    delay_label:set_text(delay_count)
  end
end)

awesome.connect_signal("visible::quicksettings", function(vis)
  if vis == false then
    screenshot:emit_signal("visible::settings", false)
    screenshot.button:turn_off()
  end
end)

return screenshot
