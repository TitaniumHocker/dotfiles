-- Dashboard configuration
local loaded, dashboard = pcall(require, "dashboard")
if not loaded then return end

local home = os.getenv("HOME")
local util = require 'packer.util'

local count_plugins = function()
    if not util then return 0 end
    local extpath = vim.fn.stdpath "data" .. "/site/pack/packer/start"
    local start_plugins = {}
    local start_dir_handle = vim.loop.fs_opendir(extpath, nil, 50)
    if start_dir_handle then
        local start_dir_items = vim.loop.fs_readdir(start_dir_handle)
        while start_dir_items do
            for _, item in ipairs(start_dir_items) do
                start_plugins[util.join_paths(extpath, item.name)] = true
            end

            start_dir_items = vim.loop.fs_readdir(start_dir_handle)
        end
    end
    return #vim.tbl_keys(start_plugins)
end

local function pad(config)
    local height = vim.api.nvim_win_get_height(0)
    local center = math.ceil( height / 2)
    local dbc = math.ceil((#config.center + #config.center - 1 + #config.header + #config.footer) / 2)
    for i =1 , center -dbc do
        table.insert(config.header, 1, '')
    end
    return config
end

-- local asciiart = {
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

local asciiart = {
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



dashboard.setup ({
    theme = "doom",
    config = pad({
        header = asciiart,
        center = {
            {
                icon = "  ",
                desc = "Find file",
                action = "Telescope find_files",
                key = 'b',
                icon_hl = 'Title',
                desc_hl = 'String',
                key_hl = 'Number',
            },
            {
                icon = "  ",
                desc = "New file",
                action = ":ene!",
                key = 'f',
                icon_hl = 'Title',
                desc_hl = 'String',
                key_hl = 'Number',
            },
            {
                icon = "  ",
                desc = "Recent projects",
                action = "Telescope projects",
                key = 'p',
                icon_hl = 'Title',
                desc_hl = 'String',
                key_hl = 'Number',
            },
            {
                icon = "  ",
                desc = "Recently used files",
                action = "Telescope oldfiles",
                key = 'u',
                icon_hl = 'Title',
                desc_hl = 'String',
                key_hl = 'Number',
            },
            {
                icon = "  ",
                desc = "Find word",
                action = "Telescope live_grep",
                key = 'g',
                icon_hl = 'Title',
                desc_hl = 'String',
                key_hl = 'Number',
            },
            {
                icon = "  ",
                desc = "Configuration",
                action = ":e ~/.config/nvim",
                key = 'c',
                icon_hl = 'Title',
                desc_hl = 'String',
                key_hl = 'Number',
            },
        },
        footer = { '', '', '  neovim loaded ' .. count_plugins() .. ' packages' }
    })
})
