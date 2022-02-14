local loaded, tree = pcall(require, "nvim-tree")
if not loaded then return end

tree.setup()

local opts = {
    noremap = true,
    silent = true,
}

local kmap = vim.api.nvim_set_keymap
local nmap = function(from, to)
    return kmap("n", from, to, opts)
end
local imap = function(from, to)
    return kmap("i", from, to, opts)
end
local vmap = function(from, to)
    return kmap("v", from, to, opts)
end

nmap("<C-n>", ":NvimTreeToggle<CR>")
nmap("<leader>r", ":NvimTreeRefresh<CR>")
nmap("<leader>n", ":NvimTreeFindFile<CR>")
