local loaded, lsp = pcall(require, "lspconfig")
if not loaded then return end

local key = require("ded.key")

key.nmap("<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
key.nmap("[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
key.nmap("]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
key.nmap("<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")

local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    key.bnmap(bufnr, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    key.bnmap(bufnr, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    key.bnmap(bufnr, "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    key.bnmap(bufnr, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    key.bnmap(bufnr, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    key.bnmap(bufnr, "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
    key.bnmap(bufnr, "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
    key.bnmap(bufnr, "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
    key.bnmap(bufnr, "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    key.bnmap(bufnr, "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    key.bnmap(bufnr, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    key.bnmap(bufnr, "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    key.bnmap(bufnr, "<leader>b", "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

local setup = function(name, settings)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local loaded, lspcmp = pcall(require, "cmp_nvim_lsp")
    if loaded then
        capabilities = lspcmp.update_capabilities(capabilities)
    end
    lsp[name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = settings,
    }
    lsp[name].manager.try_add()
end

return { setup = setup }
