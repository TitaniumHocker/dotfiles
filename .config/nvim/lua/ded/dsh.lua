-- Dashboard configuration
local loaded, dashboard = pcall(require, "dashboard")
if not loaded then return end

local home = os.getenv("HOME")

-- dashboard.custom_header = {
--     "",
--     "    _   __         _    ___              ____  ____  ______",
--     "   / | / /__  ____| |  / (_)___ ___     / __ \\\\/ __ \\\\/ ____/",
--     "  /  |/ / _ \\\\/ __ \\\\ | / / / __ `__ \\\\   / /_/ / / / / __/   ",
--     " / /|  /  __/ /_/ / |/ / / / / / / /  / ____/ /_/ / /___   ",
--     "/_/ |_/\\\\___/\\\\____/|___/_/_/ /_/ /_/  /_/   /_____/_____/   ",
--     "                                                           ",
--     "",
--     "",
-- }

dashboard.custom_header = {
    "",
    "    ______                                  __  __                       ",
    "   / ____/___  ________ _   _____  _____    \\ \\/ /___  __  ______  ____ _",
    "  / /_  / __ \\/ ___/ _ \\ | / / _ \\/ ___/     \\  / __ \\/ / / / __ \\/ __ `/",
    " / __/ / /_/ / /  /  __/ |/ /  __/ /         / / /_/ / /_/ / / / / /_/ / ",
    "/_/    \\____/_/   \\___/|___/\\___/_/         /_/\\____/\\__,_/_/ /_/\\__, /  ",
    "                                                                /____/   ",
    "    ______                                  ____                   __  ",
    "   / ____/___  ________ _   _____  _____   / __ \\_______  ______  / /__",
    "  / /_  / __ \\/ ___/ _ \\ | / / _ \\/ ___/  / / / / ___/ / / / __ \\/ //_/",
    " / __/ / /_/ / /  /  __/ |/ /  __/ /     / /_/ / /  / /_/ / / / / ,<   ",
    "/_/    \\____/_/   \\___/|___/\\___/_/     /_____/_/   \\__,_/_/ /_/_/|_|  ",
    "                                                                       ",
    "",
    "",
}

dashboard.custom_center = {
    {
        icon = "  ",
        desc = "Find file",
        action = "Telescope find_files"
    },
    {
        icon = "  ",
        desc = "New file",
        action = ":ene!"
    },
    {
        icon = "  ",
        desc = "Recent projects",
        action = "Telescope projects"
    },
    {
        icon = "  ",
        desc = "Recently used files",
        action = "Telescope oldfiles"
    },
    {
        icon = "  ",
        desc = "Find word",
        action = "Telescope live_grep"
    },
    {
        icon = "  ",
        desc = "Configuration",
        action = ":e ~/.config/nvim"
    }
}


-- vim.g["dashboard_default_executive"] = "telescope"
-- vim.g["dashboard_custom_section"] = {
--     a = {
--         description = { "  Find File          " },
--         command = "Telescope find_files",
--     },
--     b = {
--         description = { "  New File           " },
--         command = ":ene!",
--     },
--     c = {
--         description = { "  Recent Projects    " },
--         command = "Telescope projects",
--     },
--     d = {
--         description = { "  Recently Used Files" },
--         command = "Telescope oldfiles",
--     },
--     e = {
--         description = { "  Find Word          " },
--         command = "Telescope live_grep",
--     },
--     f = {
--         description = { "  Configuration      " },
--         command = ":e ~/.config/nvim/init.lua",
--     },
-- }
--[[ Breaks with fish
vim.g["dashboard_preview_command"] = "cat"
vim.g["dashboard_preview_pipeline"] = "lolcat"
vim.g["dashboard_preview_file"] = "~/.config/nvim/banner.txt"
vim.g["dashboard_preview_file_height"] = 6
vim.g["dashboard_preview_file_width"] = 20
]]
