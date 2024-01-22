local wbutton = require("utils.button")
local dpi = Beautiful.xresources.apply_dpi

local mktemplate = function(opts)
  opts.state_label_on = "Encendido"
  opts.state_label_off = "Apagado"
  local base_settings = opts.settings
      and wbutton.text.state({
        text = "󰅂",
        font = Beautiful.font_icon,
        fg_normal = Beautiful.fg_normal,
        fg_press_on = Beautiful.foreground_alt,
        fg_normal_on = Beautiful.foreground_alt,
        bg_normal_on = Beautiful.accent_color,
        size = 14,
        on_release = function()
          opts.settings()
        end,
      })
      or nil

  local base_label = Wibox.widget({
    widget = Wibox.container.background,
    {
      layout = Wibox.layout.fixed.horizontal,
      spacing = 10,
      {
        widget = Wibox.widget.textbox,
        id = "icon",
        text = opts.icon,
        font = Beautiful.font_icon .. "15",
        halign = "center",
        valign = "center",
      },
      {
        layout = Wibox.layout.fixed.vertical,
        {
          widget = Wibox.widget.textbox,
          id = "label",
          text = opts.name,
          font = Beautiful.font_text .. "Medium 10",
          halign = "left",
          valign = "top",
        },
        {
          widget = Wibox.widget.textbox,
          id = "label_state",
          text = "Apagado",
          font = Beautiful.font_text .. "Medium 9",
          halign = "left",
          valign = "bottom",
        },
      },
    },
  })

  local function turn_on_btn()
    base_label.fg = Beautiful.foreground_alt
    if base_settings then
      base_settings:turn_on()
    end
    Helpers.gc(base_label, "label_state"):set_text(opts.state_label_on)
  end
  local function turn_off_btn()
    base_label.fg = Beautiful.fg_normal
    if base_settings then
      base_settings:turn_off()
    end
    Helpers.gc(base_label, "label_state"):set_text(opts.state_label_off)
  end
  local base_button = wbutton.elevated.state({
    child = base_label,
    bg_normal = Beautiful.quicksettings_widgets_bg,
    bg_normal_on = Beautiful.accent_color,
    halign = "left",
    on_turn_on = function()
      turn_on_btn()
      if opts.on_fn then
        opts.on_fn()
      end
    end,
    on_turn_off = function()
      turn_off_btn()
      if opts.off_fn then
        opts.off_fn()
      end
    end,
  })

  local base_layout = Wibox.widget({
    widget = Wibox.container.background,
    shape = Beautiful.quicksettings_ctrl_btn_shape,
    {
      layout = Wibox.layout.align.horizontal,
      nil,
      base_button,
      base_settings,
    },
  })
  function base_layout:turn_on()
    base_button:turn_on()
    turn_on_btn()
  end

  function base_layout:turn_off()
    base_button:turn_off()
    turn_off_btn()
  end

  function base_layout:set_text(text)
    Helpers.gc(base_label, "label_state"):set_text(text)
  end

  function base_layout:set_icon(icon)
    Helpers.gc(base_label, "icon"):set_text(icon)
  end

  if opts.on_by_default then
    base_layout:turn_on()
  end

  return base_layout
end

return mktemplate
