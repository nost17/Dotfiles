local _module = {}
_module = require("utils.helpers._markup")

function _module.colorize_text(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

return _module
