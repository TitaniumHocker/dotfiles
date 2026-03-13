local loaded, treesitter = pcall(require, "nvim-treesitter.configs")
if not loaded then return end

treesitter.setup {
    ensure_installed = {
        "help",
        "perl",
        "python",
        "c",
        "rust",
        "javascript",
        "typescript",
        "lua",
        "elixir",
        "yaml",
        "json",
        "ini",
        "nginx",
        "odin",
        "haskell"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { "python", "yaml" },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
        }
    }
}
