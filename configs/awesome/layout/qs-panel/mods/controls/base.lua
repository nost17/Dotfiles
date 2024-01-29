local wbutton = require("utils.button")
local dpi = Beautiful.xresources.apply_dpi

local mktemplate = function(opts)
  opts.state_label_on = opts.state_label_on or "Encendido"
  opts.state_label_off = opts.state_label_off or "Apagado"
  local base_settings = opts.settings
      and wbutton.text.state({
        text = "󰅂",
        font = Beautiful.font_icon,
        fg_normal = Beautiful.fg_normal,
        fg_press_on = Beautiful.foreground_alt,
        fg_normal_on = Beautiful.foreground_alt,
        bg_normal = Beautiful.quicksettings_ctrl_btn_bg,
        bg_normal_on = Beautiful.accent_color,
        size = 14,
        on_release = function()
          opts.settings()
        end,
      })
      or nil

  local base_label = Wibox.widget({
    widget = Wibox.container.background,
    fg = Beautiful.fg_normal .. "CF",
    {
      layout = Wibox.layout.fixed.horizontal,
      spacing = dpi(9),
      {
        widget = Wibox.widget.textbox,
        id = "icon",
        text = opts.icon,
        font = Beautiful.font_icon .. "14",
        halign = "center",
        valign = "center",
      },
      {
        widget = Wibox.widget.textbox,
        id = "label",
        text = opts.name,
        ellipsize = "none",
        wrap = "word",
        font = Beautiful.font_text .. "Medium 10",
        halign = "center",
        valign = "center",
      },
    },
  })

  local function turn_on_btn()
    base_label.fg = Beautiful.foreground_alt
    if base_settings then
      base_settings:turn_on()
    end
  end
  local function turn_off_btn()
    base_label.fg = Beautiful.fg_normal .. "CF"
    if base_settings then
      base_settings:turn_off()
    end
  end
  local base_button = wbutton.elevated.state({
    child = base_label,
    fg_normal_on = Beautiful.foreground_alt,
    bg_normal = Beautiful.quicksettings_ctrl_btn_bg,
    bg_normal_on = Beautiful.accent_color,
    halign = "left",
    paddings = {
      left = dpi(10),
      right = dpi(8),
      top = dpi(8),
      bottom = dpi(8)
    },
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
    on_release = opts.on_release and function()
      opts.on_release()
    end,
  })

  local base_layout = Wibox.widget({
    widget = Wibox.container.background,
    shape = Beautiful.quicksettings_ctrl_btn_shape,
    {
      layout = Wibox.layout.align.horizontal,
      forced_height = dpi(42),
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
    Helpers.gc(base_label, "label").text = text
  end

  function base_layout:set_icon(icon)
    -- base_button:set_text(icon)
    Helpers.gc(base_label, "icon"):set_text(icon)
  end

  if opts.on_by_default then
    base_layout:turn_on()
  end

  return base_layout
end

return mktemplate
