local loaded, signature = pcall(require, "lsp_signature")
if not loaded then return end

signature.setup({
    bind = true,
    hint_prefix = "<> ",
    transparency = 15,
    handler_opts = {
        border = "rounded"
    }
})
