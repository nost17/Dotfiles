-- local autocmd = vim.api.nvim_create_autocm
local opt = vim.opt

dofile(vim.g.base46_cache .. "bufferline")

opt.swapfile = false
opt.guicursor = "i:hor50"

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
