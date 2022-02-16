local loaded, telescope = pcall(require, "telescope")
if not loaded then return end

local key = require("ded.key")

telescope.setup()

key.nmap("<leader>ff", ":Telescope find_files<CR>")
key.nmap("<leader>fg", ":Telescope live_grep<CR>")
key.nmap("<leader>fb", ":Telescope buffers<CR>")
key.nmap("<leader>fh", ":Telescope help_tags<CR>")
