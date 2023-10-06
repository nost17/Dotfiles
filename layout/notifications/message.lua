----------------------------------------------------------------------------
local textbox = require("wibox.widget.textbox")
local markup  = Helpers.text.set_markup
local message = {}
function message:set_notification(notif)
  local old = self._private.notification[1]

  if old == notif then return end

  if old then
    old:disconnect_signal("property::message",
      self._private.title_changed_callback)
    old:disconnect_signal("property::fg",
      self._private.title_changed_callback)
  end
  markup(
    self,
    notif.message,
    notif.fg,
    Beautiful.notification_font_message
  )
  self._private.notification = setmetatable({ notif }, { __mode = "v" })
  self._private.title_changed_callback()
  notif:connect_signal("property::message", self._private.title_changed_callback)
  notif:connect_signal("property::fg", self._private.title_changed_callback)
  self:emit_signal("property::notification", notif)
end

local function new(args)
  args = args or {}
  local tb = textbox()
  tb._private.notification = {}
  Gears.table.crush(tb, message, true)
  function tb._private.title_changed_callback()
    local n = tb._private.notification[1]
    if n then
      tb:set_markup_silently(n.message)
    else
      markup(
        tb,
        n.message,
        Beautiful.notification_fg,
        Beautiful.notification_font_message
      )
    end
  end

  if args.notification then
    tb:set_notification(args.notification)
  end
  return tb
end
return setmetatable(message, { __call = function(_, ...) return new(...) end })
