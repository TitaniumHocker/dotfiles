local loaded, outline = pcall(require, "outline")
if not loaded then return end
local key = require("ded.key")

outline.setup {}

key.nmap("<C-s>", ":Outline<CR>")
