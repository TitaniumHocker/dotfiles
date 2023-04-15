-- Basic keymaps

local opts = {
    noremap = true,
    silent = true,
}

-- Global keymaps shortcuts
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
local tmap = function(from, to)
    return kmap("t", from, to, opts)
end

-- Buffer keymaps shortcuts
local bmap = vim.api.nvim_buf_set_keymap
local bnmap = function(buf, from, to)
    return bmap(buf, "n", from, to, opts)
end
local bimap = function(buf, from, to)
    return bmap(buf, "i", from, to, opts)
end
local bvmap = function(buf, from, to)
    return bmap(buf, "v", from, to, opts)
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


-- Export shortcuts
return {
    kmap = kmap,
    nmap = nmap,
    imap = imap,
    vmap = vmap,
    tmap = tmap,
    bmap = bmap,
    bnmap = bnmap,
    bimap = bimap,
    bvmap = bvmap,
}
