local loaded, lsp = pcall(require, "ded.lsp")
if not loaded then return end
-- lsp.setup("pyright", {})
lsp.setup("ty", {})
lsp.setup("ts_ls", {})
lsp.setup("clangd", {})
