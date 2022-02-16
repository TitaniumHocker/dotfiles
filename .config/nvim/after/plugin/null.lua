local loaded, null = pcall(require, "null-ls")
if not loaded then return end

null.setup {
    sources = {
        null.builtins.formatting.black,
        null.builtins.formatting.isort
    }
}
