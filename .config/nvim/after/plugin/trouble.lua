local loaded, trouble = pcall(require, "trouble")
if not loaded then return end
local key = require("ded.key")

trouble.setup {
    position = "right",
}

key.nmap("<leader>tt", ":TroubleToggle<CR>")
key.nmap("<leader>tf", ":Trouble document_diagnostics<CR>")
key.nmap("<leader>tw", ":Trouble workspace_diagnostics<CR>")
key.nmap("<leader>tr", ":Trouble lsp_references<CR>")
key.nmap("<leader>td", ":Trouble lsp_definitions<CR>")
