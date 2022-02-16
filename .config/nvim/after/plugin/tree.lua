local loaded, tree = pcall(require, "nvim-tree")
if not loaded then return end

local key = require("ded.key")

tree.setup {
    diagnostics = {
        enable = true
    }
}

key.nmap("<C-n>", ":NvimTreeToggle<CR>")
key.nmap("<leader>r", ":NvimTreeRefresh<CR>")
key.nmap("<leader>n", ":NvimTreeFindFile<CR>")
