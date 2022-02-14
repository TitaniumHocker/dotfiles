local loaded, cmp = pcall(require, "cmp")
if not cmp then return end

cmp.setup.buffer({
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }
})
