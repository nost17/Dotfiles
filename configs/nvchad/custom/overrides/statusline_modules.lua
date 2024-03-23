local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

local function modify_modules(modules)
  modules[4] = (function()
    if not rawget(vim, "lsp") then
      return ""
    end

    local errors = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.HINT })
    local info = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.INFO })

    local _errors = (errors and errors > 0) and ("%#St_lspError#󰅚 " .. errors .. " ") or ""
    local _warnings = (warnings and warnings > 0) and ("%#St_lspWarning# " .. warnings .. " ") or ""
    local _hints = (hints and hints > 0) and ("%#St_lspHints#󰛩 " .. hints .. " ") or ""
    local _info = (info and info > 0) and ("%#St_lspInfo# " .. info .. " ") or ""

    return vim.o.columns > 140 and _errors .. _warnings .. _hints .. _info or ""
  end)()
  modules[10] = (function()
    return ""
  end)()
  modules[9] = (function()
    return vim.o.columns > 140 and "%#StText# L:%l, C:%c " or ""
  end)()
  modules[11] = (function()
    local ft = vim.bo[stbufnr()].ft
    return ft == "" and "%#St_ft# TEXT " or "%#St_ft# " .. ft:upper() .. " %#StText#"
  end)()
  modules[#modules] = (function()
    local dir_name = "%#St_cwd# " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " 󰉖 " .. " "
    return (vim.o.columns > 85 and dir_name) or ""
  end)()
end

return modify_modules
