local loaded, treesitter = pcall(require, "nvim-treesitter")
if not loaded then return end

treesitter.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
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

local ensure_installed = {
    "vim",
    "python",
    "c",
    "javascript",
    "typescript",
    "java",
    "cpp",
    "go",
    "perl",
    "json",
    "toml",
    "yaml",
    "vue",
    "svelte",
    "lua",
    "bash",
    "fish",
    "css",
    "html",
    "jinja",
}

local already_installed = require("nvim-treesitter.config").get_installed()
local to_install = {}

for _, parser in ipairs(ensure_installed) do
    if not vim.tbl_contains(already_installed, parser) then
        table.insert(to_install, parser)
    end
end

if #to_install > 0 then
    treesitter.install(to_install)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = { '<filetype>' },
    callback = function()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start()
    end,
})
