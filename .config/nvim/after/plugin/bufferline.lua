local loaded, bufferline = pcall(require, "bufferline")
if not loaded then return end

bufferline.setup()

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

-- Go to pevious/next
nmap("<A-.>", ":BufferLineCycleNext<CR>")
nmap("<A-,>", ":BufferLineCyclePrev<CR>")
-- Move current buff previous/next
nmap("<A->>", ":BufferLineMoveNext<CR>")
nmap("<A-<>", ":BufferLineMovePrev<CR>")
