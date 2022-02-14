-- Basic keymaps
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

-- Set space as leader key
kmap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigation between splitted buffers
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

-- Use arrows to resize splitted buffers
nmap("<C-Up>", ":resize -2<CR>")
nmap("<C-Down>", ":resize +2<CR>")
nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertical resize +2<CR>")

-- Intendation change tweaks
vmap("<", "<gv")
vmap(">", ">gv")

-- Don't rewrite previously yanked after paste in visual mode
vmap("p", '"_dP')
