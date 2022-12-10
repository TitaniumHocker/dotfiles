local loaded, lsp = pcall(require, "lspconfig")
if not loaded then return end

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

lsp.tsserver.setup {}
lsp.tsserver.manager.try_add()
