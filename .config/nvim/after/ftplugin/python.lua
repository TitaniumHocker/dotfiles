local loaded, lsp = pcall(require, "lspconfig")
if not loaded then return end

-- local on_attach = require("ded.lsp").on_attach

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lsp.pyright.setup {
    -- on_attach = on_attach,
    capabilities = capabilities,
    autostart = true
}

-- Ensure that language server is attached to buffer
lsp.pyright.manager.try_add()
