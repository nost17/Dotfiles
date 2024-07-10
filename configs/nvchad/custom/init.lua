-- local autocmd = vim.api.nvim_create_autocm
local opt = vim.opt

local links = {
	["IndentBlanklineContextSpaceChar"] = "IndentBlanklineContextChar",
	["IndentBlanklineSpaceChar"] = "IndentBlanklineChar",
	["Whitespace"] = "IndentBlanklineChar",
	-- ["@lsp.type.property.lua"] = "@property",
}

for newgroup, oldgroup in pairs(links) do
	vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

opt.listchars = { space = "·", tab = "›·" }
opt.list = true
opt.swapfile = false
opt.guicursor = "i:hor50"

opt.shiftwidth = 3
opt.tabstop = 3
opt.softtabstop = 3

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
