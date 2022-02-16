local loaded, bufferline = pcall(require, "bufferline")
if not loaded then return end
local key = require("ded.key")

bufferline.setup {
    options = {
        diagnostics = "nvim_lsp",
        separator_style = "thin",
    }
}

-- Go to pevious/next
key.nmap("<A-.>", ":BufferLineCycleNext<CR>")
key.nmap("<A-,>", ":BufferLineCyclePrev<CR>")
-- Move current buff previous/next
key.nmap("<A->>", ":BufferLineMoveNext<CR>")
key.nmap("<A-<>", ":BufferLineMovePrev<CR>")

-- Select preferred buffer from 1 to 9
for i = 1, 9 do
    key.nmap("<A-" .. i .. ">", ":BufferLineGoToBuffer " .. i .. "<CR>")
end

-- Pick buffer
key.nmap("<A-p>", ":BufferLinePick<CR>")

-- Pick buffer to close
key.nmap("<A-P>", ":BufferLinePickClose<CR>")

-- Close current buffer
key.nmap("<A-c>", ":bd<BAR>bp<CR>")
