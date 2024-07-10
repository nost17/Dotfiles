local M = {}
local ibl = require("indent_blankline")

local highlight = {
  "Variable"
}

M.indent = { highlight = highlight, tab_char = "." }
M.indentLine_enabled = 1
M.show_trailing_blankline_indent = false
M.show_first_indent_level = false
M.show_current_context = true
M.show_current_context_start = true

return M
