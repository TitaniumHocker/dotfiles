local loaded, lsp = pcall(require, "lspconfig")
if not loaded then return end

lsp.vimls.setup {}
