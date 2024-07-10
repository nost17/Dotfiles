-- To find any highlight groups: "<cmd> Telescope highlights"
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
	AlphaHeader = { fg = "blue" },
	CursorLine = {
		bg = "black2",
	},
	Statement = {
		italic = true,
	},
	Define = { italic = true },
	eliixirString = { italic = true },
	Include = { italic = true },
	TSVariable = { italic = true },
	Variable = { italic = true },
	-- Type = { italic = true },
	Function = { italic = true },
	Keyword = { italic = true },
	TSKeyword = { italic = true },
	TSMethod = { italic = true },
	TSDefine = { italic = true },
	SpecialComment = { italic = true },
	["@comment"] = { italic = true },
	["@keyword"] = { italic = true },
	["@keyword.return"] = { italic = true },
	["@keyword.function"] = { italic = true },
	-- ["@variable.member"] = { fg = "cyan" },
}

---@type HLTable
M.add = {
	["@keyword.conditional.python"] = { italic = true, fg = "dark_purple" },
	["@keyword.operator.python"] = { italic = true, fg = "dark_purple" },
	["@keyword.function.python"] = { italic = true, fg = "dark_purple" },
	["@keyword.return.python"] = { fg = "orange", italic = true },
	-- ["@variable.member.lua"] = { fg = "blue" },
	NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
