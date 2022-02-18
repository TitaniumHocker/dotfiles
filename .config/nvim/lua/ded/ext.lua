-- Extensions

-- Autoinstallation
local extpath = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(extpath)) > 0 then
    autoinstalled = vim.fn.system {
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim.git", extpath
    }
    print "Installed packer. Please, reopen NeoVim"
    vim.cmd "packadd packer.nvim"
end

-- Source config after ext.lua file changed
vim.cmd [[
augroup autoreload_after_ext_added
    autocmd!
    autocmd BufWritepost ext.lua source <afile> | PackerSync
augroup END
]]

local loaded, packer = pcall(require, "packer")
if not loaded then return end

-- Force packer to use popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Here goes extensions list
return packer.startup(function(use)
    -- Base extensions
    use "wbthomason/packer.nvim"        -- Extensions manager
    use "nvim-lua/popup.nvim"           -- Implementaion of popup API from Vim
    use "nvim-lua/plenary.nvim"         -- Usefull lua functions for ext
    use "kyazdani42/nvim-web-devicons"  -- Devicons for NeoVim

    -- Themes
    use "sainnhe/gruvbox-material"      -- Old good gruvbox
    use "folke/tokyonight.nvim"         -- Pretty nice blue theme

    -- Tweaks
    use "windwp/nvim-autopairs"         -- Autopairs, integrates with cmp and treesitter
    use "folke/which-key.nvim"          -- Helps with commands

    -- Usefull things
    use "kyazdani42/nvim-tree.lua"      -- NerdTree implementation in lua
    use "tpope/vim-dispatch"            -- Build this shit up
    use "nvim-telescope/telescope.nvim" -- Awesome fuzzy finder
    use "akinsho/toggleterm.nvim"       -- Nice tetminal
    use "lewis6991/gitsigns.nvim"       -- Git integration
    use "numToStr/Comment.nvim"         -- Comment things as Jedi

    -- Visual additions
    use "hoob3rt/lualine.nvim"          -- Airline implementation in lua
    use "akinsho/bufferline.nvim"       -- Buffers and tabs status line

    -- Syntax
    use "Glench/Vim-Jinja2-Syntax"      -- Jinja2 syntax support
    use "saltstack/salt-vim"            -- Support for saltstack(sls) filetype
    use "chr4/nginx.vim"                -- Support for nginx config filetype
    use {                               -- Fast as FUCK syntax parsers
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    -- Funny shit
    use {
        "aurieh/discord.nvim",          -- Show status in Discord
        run = ":UpdateRemotePlugins",
    }

    -- Completion
    use "hrsh7th/nvim-cmp"              -- Completion engine
    use "hrsh7th/cmp-buffer"            -- Completions based on buffer
    use "hrsh7th/cmp-path"              -- Completions based on path
    use "hrsh7th/cmp-cmdline"           -- Completions based on command line
    use "hrsh7th/cmp-nvim-lua"          -- Completions for lua based config
    use "kristijanhusak/vim-dadbod-completion" -- Completios for DBMSs
    use "tpope/vim-dadbod"              -- Required for pevious one
    use "kdheepak/cmp-latex-symbols"    -- Completion for LaTeX format

    -- Snippets
    use "L3MON4D3/LuaSnip"              -- Snippets engine
    use "rafamadriz/friendly-snippets"  -- Awesome snippets pack
    use "saadparwaiz1/cmp_luasnip"      -- Completions based on snippets

    -- LSP
    use "neovim/nvim-lspconfig"         -- LSP configurations
    use "jose-elias-alvarez/null-ls.nvim" -- Adapter for formatters and linters
    use "hrsh7th/cmp-nvim-lsp"          -- Completions based on LSP
    use "folke/lsp-colors.nvim"         -- Additional colors
    use "folke/trouble.nvim"            -- Prettify LSP results

    -- Start screen
    use "glepnir/dashboard-nvim"        -- Awesome dashboard
    use "ahmedkhalf/project.nvim"       -- Project management

    if autoinstalled then
        require("packer").sync()
    end
end)
