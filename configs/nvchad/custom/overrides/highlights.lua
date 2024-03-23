-- To find any highlight groups: "<cmd> Telescope highlights"
--
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors
local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },
  St_NormalMode = { fg = "nord_blue" },
  St_ft = { fg = "black", bg = "white", bold = true },
  St_cwd = { bold = false },
  DevIconlua = { fg = "red" },
  TblineFill = { bg = "black" },
  TbLineBufOff = { bg = "black2" },
  TbLineBufOn = { fg = "white", bg = "one_bg3", bold = true },
  TbLineBufOnClose = { fg = "white", bg = "grey", bold = true },
  TbLineBufOnModified = { fg = "white", bg = "grey", bold = true },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
