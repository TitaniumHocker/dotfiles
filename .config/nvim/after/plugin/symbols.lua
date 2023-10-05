local loaded, symbols = pcall(require, "symbols-outline")
if not loaded then return end
local key = require("ded.key")

symbols.setup()

key.nmap("<C-s>", ":SymbolsOutline<CR>")
