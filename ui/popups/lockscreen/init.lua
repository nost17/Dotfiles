local dpi = Beautiful.xresources.apply_dpi
local playerctl = Lib.Playerctl
local wscreen = screen.primary.geometry.width
local hscreen = screen.primary.geometry.height
local modules = require(... .. ".modules")

local auth = function(password)
   return password == "awesome"
end

local caps = Wibox.widget({
   widget = Wibox.widget.textbox,
   font = Beautiful.font_name .. "Bold 16",
   text = "",
   halign = "right",
   valign = "center",
})

local grabber = modules.grab({
   password_box = modules.song.art,
   auth = auth,
   caps_label = caps
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
   image = Beautiful.wallpaper,
   scaling_quality = "fast",
   upscale = true,
   downscale = true,
   vertical_fit_policy = "fill",
   horizontal_fit_policy = "fill",
   forced_width = wscreen,
   forced_height = hscreen,
})

local overlay = Wibox.widget({
   widget = Wibox.container.background,
   forced_width = wscreen,
   forced_height = hscreen,
   bg = Beautiful.neutral[900],
   opacity = Beautiful.type == "dark" and 0.8 or 0.5,
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
               format = "%H:%M",
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
                        markup = Helpers.text.colorize_text("Escuchando ahora", Beautiful.fg_normal),
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
