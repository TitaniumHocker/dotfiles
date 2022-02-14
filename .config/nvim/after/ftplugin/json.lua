local loaded, lsp = pcall(require, "lspconfig")
if not loaded then return end

lsp.jsonls.setup {}
