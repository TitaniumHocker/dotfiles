local loaded, cmp = pcall(require, "cmp")
if not cmp then return end

cmp.setup.buffer({
    sources = {
        { name = "spell" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }
})
