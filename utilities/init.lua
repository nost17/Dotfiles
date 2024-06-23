local utils = {}

---@module 'utilities.widgets'
utils.widgets = require(... .. ".widgets")
---@module 'utilities.icon_theme'
utils.apps_info = require(... .. ".icon_theme")()
---@module 'utilities.screenshot'
utils.screenshot = require(... .. ".screenshot")

return utils
