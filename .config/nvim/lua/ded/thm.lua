-- Themes configuration

local themes = {
    gruvbox = function()
        -- vim.o.background = "dark"
        vim.o.background = "light"
        vim.g.gruvbox_material_transparent_background = 1
        vim.g.gruvbox_material_background = "soft" -- "medium" | "soft" | "hard"
        vim.g.gruvbox_material_palette = "original" -- "material" | "mix" | "original"
        vim.g.gruvbox_material_statusline_style = "original" -- "default" | "mix" | "original"
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_disable_italic_comment = 1
        vim.cmd "colorscheme gruvbox-material"
    end
}

local colorscheme = function(value)
    local status, err = pcall(themes[value])
    if not status then
        vim.cmd "colorscheme default"
        vim.notify("Failed to set colorscheme " .. value .. "\nError: " .. err)
    end
end

return {
    colorscheme = colorscheme
}
