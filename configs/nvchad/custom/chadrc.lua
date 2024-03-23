---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.overrides.highlights"
local custom_modules = require("custom.overrides.statusline_modules")
local statusline_theme = "vscode_colored"

local override_colors = {
  yoru = {
    base_16 = {
      base00 = "#161819",
      base02 = "#27292a",
    },
    base_30 = {
      black = "#161819",
      darker_black = "#0c0e0f",
      one_bg = "#27292a",
    },
  },
}

M.ui = {
  extended_integrations = { 'bufferline'},
  theme = "doomchad",
  theme_toggle = { "doomchad", "one_light" },
  nvdash = { load_on_startup = true },
  cmp = {
    style = "flat_light",
  },
  hl_override = highlights.override,
  hl_add = highlights.add,
  changed_themes = override_colors,
  statusline = {
    theme = statusline_theme,
    overriden_modules = function(modules)
      if statusline_theme == "vscode_colored" then
        custom_modules(modules)
      end
    end,
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
