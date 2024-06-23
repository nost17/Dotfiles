local utils = {}

---@module 'widgets'
utils.widgets = require(... .. ".widgets")
utils.apps_info = require(... .. ".icon_theme")()
utils.screenshot = require(... .. ".screenshot")

return utils
