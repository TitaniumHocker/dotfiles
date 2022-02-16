local loaded, lsp = pcall(require, "lspconfig")
if not loaded then return end

lsp.clangd.setup {}

-- Ensure that language server is attached to buffer
lsp.clangd.manager.try_add()
