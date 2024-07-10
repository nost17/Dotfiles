local dpi = Beautiful.xresources.apply_dpi
-- local playerctl = Lib.Playerctl
local wscreen = screen.primary.geometry.width
local hscreen = screen.primary.geometry.height

local auth = function(password)
   return password == "awesome"
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

local grabber = modules.grab({
   password_box = modules.song.art,
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
   opacity = Beautiful.type == "dark" and 0.8 or 0.35,
})

main:setup({
   layout = Wibox.layout.stack,
   back,
   overlay,
   {
      widget = Wibox.container.margin,
      margins = 100,
      {
         layout = Wibox.layout.align.vertical,
         {
            layout = Wibox.layout.align.horizontal,
            {
               widget = Wibox.widget.textclock,
               font = Beautiful.font_name .. " Bold 100",
               format = Helpers.text.colorize_text("%H:%M", Beautiful.lockscreen_fg),
               align = "center",
               valign = "center",
            },
            nil,
            caps,
         },
         nil,
         {
            widget = Wibox.container.place,
            valign = "center",
            halign = "left",
            {
               layout = Wibox.layout.fixed.horizontal,
               spacing = Beautiful.widget_padding.outer * 1.6,
               modules.song.art,
               {
                  widget = Wibox.container.place,
                  valign = "center",
                  halign = "left",
                  {
                     layout = Wibox.layout.fixed.vertical,
                     {
                        widget = Wibox.widget.textbox,
                        font = Beautiful.font_name .. "Bold 22",
                        halign = "start",
                        markup = Helpers.text.colorize_text("Escuchando ahora", Beautiful.lockscreen_fg),
                     },
                     modules.song.name,
                  },
               },
            },
         },
      },
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
