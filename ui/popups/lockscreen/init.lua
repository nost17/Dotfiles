local dpi = Beautiful.xresources.apply_dpi
-- local playerctl = Lib.Playerctl
local wscreen = screen.primary.geometry.width
local hscreen = screen.primary.geometry.height

local auth = function(password)
   return password == (User.config.password or "awesome")
end

Beautiful.lockscreen_overlay_bg = Beautiful.neutral[800]
Beautiful.lockscreen_fg = Beautiful.neutral[100]
Beautiful.lockscreen_passbox_bg = Beautiful.transparent
Beautiful.lockscreen_passbox_bg_error = Beautiful.red[300]
Beautiful.lockscreen_passbox_bg_empty = Beautiful.lockscreen_passbox_bg

if Beautiful.type == "light" then
   Beautiful.lockscreen_overlay_bg = Beautiful.neutral[200]
   Beautiful.lockscreen_fg = Beautiful.neutral[800]
end

local modules = require(... .. ".modules")

local caps = Wibox.widget({
   widget = Wibox.widget.textbox,
   font = Beautiful.font_name .. "Bold 16",
   markup = "",
   halign = "right",
   valign = "center",
})

local grab_arc = Wibox.widget({
   id = "arc",
   widget = Wibox.container.arcchart,
   max_value = 100,
   min_value = 0,
   value = 0,
   rounded_edge = false,
   thickness = dpi(3),
   start_angle = 4.71238898,
   bg = Beautiful.lockscreen_passbox_bg,
   colors = { Beautiful.lockscreen_passbox_bg },
   -- bg = Beautiful.neutral[300] .. "cc",
   -- colors = { Beautiful.neutral[300] .. "cc" },
   shape = Gears.shape.circle,
   forced_width = dpi(100),
   forced_height = dpi(100),
   {
      widget = Wibox.container.place,
      valign = "center",
      halign = "center",
      {
         widget = Utils.widgets.icon,
         valign = "center",
         halign = "center",
         icon = {
            path = Beautiful.icons .. "power/lock2.svg",
            uncached = true,
         },
         size = 42,
         color = Beautiful.lockscreen_fg,
      },
   }
})

local grabber = modules.grab({
   password_box = grab_arc,
   auth = auth,
   caps_label = caps,
})

local main = Wibox({
   width = wscreen,
   height = hscreen,
   visible = false,
   ontop = true,
   type = "splash",
})

local back = Wibox.widget({
   widget = Wibox.widget.imagebox,
   halign = "center",
   valign = "center",
   image = Gears.surface.crop_surface({
      ratio = wscreen / hscreen,
      surface = Gears.surface.load_uncached(Beautiful.wallpaper),
   }),
   scaling_quality = "fast",
   horizontal_fit_policy = "fit",
   vertical_fit_policy = "fit",
})

local overlay = Wibox.widget({
   widget = Wibox.container.background,
   forced_width = wscreen,
   forced_height = hscreen,
   bg = Beautiful.lockscreen_overlay_bg,
   opacity = Beautiful.type == "dark" and 0.8 or 0.5,
})


local bar = Wibox.widget({
   widget = Wibox.container.background,
   bg = Beautiful.widget_color[1],
   forced_height = dpi(48),
   {
      widget = Wibox.container.margin,
      top = Beautiful.widget_padding.inner * 0.7,
      bottom = Beautiful.widget_padding.inner * 0.7,
      left = Beautiful.widget_padding.inner,
      right = Beautiful.widget_padding.inner,
      {
         layout = Wibox.layout.align.horizontal,
         expand = "none",
         modules.info,
         modules.song,
         modules.actions,
      }
   }
})

main:setup({
   layout = Wibox.layout.stack,
   back,
   overlay,
   {
      layout = Wibox.layout.align.vertical,
      {
         widget = Wibox.container.margin,
         margins = 100,
         {
            layout = Wibox.layout.align.horizontal,
            expand = "none",
            nil,
            {
               layout = Wibox.layout.fixed.vertical,
               {
                  widget = Wibox.widget.textclock,
                  font = Beautiful.font_name .. " Medium 82",
                  format = Helpers.text.colorize_text("%H:%M", Beautiful.lockscreen_fg),
                  align = "center",
                  valign = "center",
               },
               {
                  widget = Wibox.container.margin,
                  top = dpi(-10),
                  modules.date
               }
            },
            caps,
         },
      },
      {
         widget = Wibox.container.place,
         halign = "center",
         valign = "center",
         grab_arc
      },
      bar,
   },
})

awesome.connect_signal("widgets::lockscreen", function(action)
   if action == "toggle" then
      main.visible = not main.visible
   elseif action == "show" then
      main.visible = true
   elseif action == "hide" then
      main.visible = false
   end
   awesome.emit_signal("visible::lockscreen", main.visible)
   if main.visible then
      grabber:start()
   end
end)
