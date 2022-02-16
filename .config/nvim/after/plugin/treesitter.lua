local loaded, treesitter = pcall(require, "nvim-treesitter.configs")
if not loaded then return end

treesitter.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
        disable = { "python", "yaml" },
    },
}
