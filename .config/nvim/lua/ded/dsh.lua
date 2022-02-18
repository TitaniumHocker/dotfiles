-- Dashboard configuration

vim.g["dashboard_default_executive"] = "telescope"
vim.g["dashboard_custom_section"] = {
    a = {
        description = { "  Find File          " },
        command = "Telescope find_files",
    },
    b = {
        description = { "  New File           " },
        command = ":ene!",
    },
    c = {
        description = { "  Recent Projects    " },
        command = "Telescope projects",
    },
    d = {
        description = { "  Recently Used Files" },
        command = "Telescope oldfiles",
    },
    e = {
        description = { "  Find Word          " },
        command = "Telescope live_grep",
    },
    f = {
        description = { "  Configuration      " },
        command = ":e ~/.config/nvim/init.lua",
    },
}
--[[ Breaks with fish
vim.g["dashboard_preview_command"] = "cat"
vim.g["dashboard_preview_pipeline"] = "lolcat"
vim.g["dashboard_preview_file"] = "~/.config/nvim/banner.txt"
vim.g["dashboard_preview_file_height"] = 6
vim.g["dashboard_preview_file_width"] = 20
]]
