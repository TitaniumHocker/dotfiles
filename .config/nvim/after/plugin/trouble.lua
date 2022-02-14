local loaded, trouble = pcall(require, "trouble")
if not loaded then return end


trouble.setup {
    position = "right",
}

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

nmap("<leader>tt", ":TroubleToggle<CR>")
nmap("<leader>tf", ":Trouble document_diagnostics<CR>")
nmap("<leader>tw", ":Trouble document_diagnostics<CR>")
nmap("gR", ":Trouble lsp_references<CR>")
nmap("gD", ":Trouble lsp_definitions<CR>")
