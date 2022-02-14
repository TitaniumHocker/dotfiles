local loaded, colors = pcall(require, "lsp-colors")
if not colors then return end

colors.setup()
