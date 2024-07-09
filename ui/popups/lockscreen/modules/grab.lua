local accent = Beautiful.primary[500]

local reset = function(f, arc)
   arc.value = not f and 100 or 0
   arc.colors = { not f and Beautiful.lockscreen_passbox_bg_error or Beautiful.lockscreen_passbox_bg }
end

local getRandom = function()
   local r = math.random(0, 628)
   r = r / 100
   return r
end

local check_caps = function(label)
   Awful.spawn.easy_async_with_shell("xset q | grep Caps | cut -d: -f3 | cut -d0 -f1 | tr -d ' '", function(stdout)
      if stdout:match("off") then
         label.markup = ""
      else
         label.markup = Helpers.text.colorize_text("Mayúsculas: ENCENDIDO", Beautiful.lockscreen_fg)
      end
   end)
end

local input = ""
local function grab(args)
   local arc = Helpers.gc(args.password_box, "arc")
   local grabber = Awful.keygrabber({
      auto_start = true,
      stop_event = "release",
      mask_event_callback = true,
      keybindings = {
         Awful.key({
            modifiers = { "Mod1", "Mod4", "Shift", "Control" },
            key = "Return",
            on_press = function(_)
               input = input
            end,
         }),
      },
      keypressed_callback = function(_, _, key, _)
         if key == "Escape" then
            input = ""
            return
         end
         -- Accept only the single charactered key
         -- Ignore 'Shift', 'Control', 'Return', 'F1', 'F2', etc., etc.
         if #key == 1 then
            arc.colors = { accent }
            arc.value = 20
            arc.start_angle = getRandom()
            if input == nil then
               input = key
               return
            end
            input = input .. key
         elseif key == "BackSpace" then
            arc.colors = { accent }
            arc.value = 20
            arc.start_angle = getRandom()
            input = input:sub(1, -2)
            if #input == 0 then
               arc.colors = { Beautiful.lockscreen_passbox_bg_empty }
               arc.value = 100
            end
         end
      end,
      keyreleased_callback = function(self, _, key, _)
         -- Validation
         if key == "Return" then
            if args.auth(input) then
               self:stop()
               reset(true, arc)
               awesome.emit_signal("widgets::lockscreen", "hide")
               -- visible(false)
               input = ""
            else
               -- grab()
               reset(false, arc)
               input = ""
            end
         elseif key == "Caps_Lock" then
            check_caps(args.caps_label)
         end
      end,
   })
   return grabber
end
return grab
