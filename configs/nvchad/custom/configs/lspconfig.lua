local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

capabilities.textDocument.completion.completionItem.preselectSupport = false

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "clangd", "bashls", "jsonls", "pyright" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

lspconfig.lua_ls.setup({
  -- on_attach = on_attach,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          ["/home/corvus/code/awesome-code-doc"] = true,
          ["/usr/local/share/awesome/lib"] = true,
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

--
-- lspconfig.pyright.setup { blabla}
