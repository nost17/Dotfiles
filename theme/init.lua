-- Theme handling library
-- Standard awesome library
local color_lib = Helpers.color
local theme = {}
local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local dpi = Beautiful.xresources.apply_dpi

Beautiful.init(theme)
