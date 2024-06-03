local utils = {}

utils.widgets = require(... .. ".widgets")
utils.get_icon = require(... .. ".icon_theme")()
utils.screenshot = require(... .. ".screenshot")

return utils
