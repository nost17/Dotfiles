local layoutlist = require("layout.popups.layout_switcher.layoutlist")
local color_lib = Helpers.color
local dpi = Beautiful.xresources.apply_dpi
Beautiful.layout_switcher_shape = nil
Beautiful.layoutlist_bg_color = Beautiful.widget_bg_alt
Beautiful.layoutlist_shape_selected = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.layoutlist_bg_selected =
    color_lib.lightness(Beautiful.color_method, Beautiful.color_method_factor * 1.5, Beautiful.layoutlist_bg_color)
Beautiful.layoutlist_icon_color =
    color_lib.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.layoutlist_bg_color)

local ll = layoutlist({
  screen = Awful.screen.focused(),
  base_layout = Wibox.widget({
    spacing = 5,
    -- forced_num_cols = 6,
    -- forced_num_rows = 1,
    layout = Wibox.layout.grid.horizontal,
  }),
  widget_template = {
    widget = Wibox.container.background,
    id = "background_role",
    forced_width = dpi(85),
    forced_height = dpi(85),
    shape = Gears.shape.rounded_rect,
    {
      widget = Wibox.container.margin,
      margins = dpi(20),
      {
        widget = Wibox.widget.imagebox,
        id = "icon_role",
      },
    },
  },
})

local layout_switcher = Awful.popup({
  bg = Beautiful.layout_switcher_bg,
  screen = Awful.screen.focused(),
  visible = false,
  ontop = true,
  placement = function(c)
    Helpers.placement(c, "centered")
  end,
  maximum_width = Awful.screen.focused().geometry.width,
  maximum_height = Awful.screen.focused().geometry.height,
  widget = {
    widget = Wibox.container.margin,
    margins = dpi(15),
    ll,
  },
})

local wdg_timer = Gears.timer({
  timeout = 0.4,
  autostart = false,
  single_shot = true,
  callback = function()
    layout_switcher.visible = false
  end,
})

tag.connect_signal("property::layout", function()
  layout_switcher.visible = true
  wdg_timer:again()
end)
