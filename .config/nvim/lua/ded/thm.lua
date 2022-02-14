-- Themes configuration

-- Gruvbox
--[[
vim.o.background = "dark"
vim.g.gruvbox_material_transparent_background = 1
vim.g.gruvbox_material_background = "soft" -- "medium" | "soft" | "hard"
vim.g.gruvbox_material_palette = "original" -- "material" | "mix" | "original"
vim.g.gruvbox_material_statusline_style = "original" -- "default" | "mix" | "original"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_disable_italic_comment = 1
vim.cmd "colorscheme gruvbox-material"
]]

-- tokyonight colorscheme configuration
vim.o.background = "dark"
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_transparent = 1
vim.cmd "colorscheme tokyonight"
