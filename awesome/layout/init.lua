require("layout.notify")
require("layout.main-panel")
require("layout.app-launcher")
require("layout.popups")
require("layout.notify-panel")
require("layout.decorations")
collectgarbage("collect")

awesome.connect_signal("visible::quicksettings", function(vis)
  if vis then
    awesome.emit_signal("panels::app_launcher", "hide")
    awesome.emit_signal("panels::notification_center", "hide")
    awesome.emit_signal("panels::calendar", "hide")
  end
end)
--
awesome.connect_signal("visible::app_launcher", function(vis)
  if vis then
    awesome.emit_signal("panels::quicksettings", "hide")
    awesome.emit_signal("panels::notification_center", "hide")
    awesome.emit_signal("panels::calendar", "hide")
  end
end)
--
awesome.connect_signal("visible::notification_center", function(vis)
  if vis then
    awesome.emit_signal("panels::quicksettings", "hide")
    awesome.emit_signal("panels::app_launcher", "hide")
    awesome.emit_signal("panels::calendar", "hide")
  end
end)
--
awesome.connect_signal("visible::calendar", function(vis)
  if vis then
    awesome.emit_signal("panels::quicksettings", "hide")
    awesome.emit_signal("panels::notification_center", "hide")
    awesome.emit_signal("panels::app_launcher", "hide")
  end
end)
