local loaded, treesitter = pcall(require, "nvim-treesitter.configs")
if not loaded then return end

treesitter.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = true,
        disable = {},
    },
}
