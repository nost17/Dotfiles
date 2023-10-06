----------------------------------------------------------------------------
local textbox = require("wibox.widget.textbox")
local markup  = Helpers.text.set_markup
local title   = {}
function title:set_notification(notif)
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
    notif.title,
    notif.fg,
    Beautiful.notification_font_title
  )
  -- self:set_markup_silently(mktext.colorize_text(mktext.text_for_markup(notif.title or ""), beautiful.notification_fg))
  -- self:set_font(notif.font or beautiful.notification_font_title)

  self._private.notification = setmetatable({ notif }, { __mode = "v" })
  self._private.title_changed_callback()
  notif:connect_signal("property::title", self._private.title_changed_callback)
  notif:connect_signal("property::fg", self._private.title_changed_callback)
  self:emit_signal("property::notification", notif)
end

local function new(args)
  args = args or {}
  local tb = textbox()
  tb._private.notification = {}
  Gears.table.crush(tb, title, true)
  function tb._private.title_changed_callback()
    local n = tb._private.notification[1]
    if n then
      tb:set_markup_silently(n.title)
    else
      markup(
        tb,
        n.title,
        Beautiful.notification_fg,
        Beautiful.notification_font_title
      )
      -- tb:set_markup_silently(mktext.colorize_text(mktext.text_for_markup(n.title), beautiful.notification_fg))
      -- tb:set_font(beautiful.notification_font_title)
    end
  end

  if args.notification then
    tb:set_notification(args.notification)
  end
  return tb
end
return setmetatable(title, { __call = function(_, ...) return new(...) end })
