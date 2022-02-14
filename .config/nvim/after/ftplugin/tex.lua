local loaded, cmp = pcall(require, "cmp")
if not cmp then return end

cmp.setup.buffer({
    sources = {
        { name = "latex_symbols" },
        { name = "spell" },
        { name = "buffer" },
        { name = "path" },
    }
})
