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
    -- use "tanvirtin/monokai.nvim"        -- monokai(from sublimetext)

    -- Tweaks
    use "windwp/nvim-autopairs"         -- Autopairs, integrates with cmp and treesitter
    use "folke/which-key.nvim"          -- Helps with commands

    -- Usefull things
    use "kyazdani42/nvim-tree.lua"      -- NerdTree implementation in lua
    use "nvim-telescope/telescope.nvim" -- Awesome fuzzy finder
    use "akinsho/toggleterm.nvim"       -- Nice tetminal
    use "lewis6991/gitsigns.nvim"       -- Git integration
    use "numToStr/Comment.nvim"         -- Comment things as Jedi
    use 'simrat39/symbols-outline.nvim' -- Tree for code symbols(like ctags)

    -- Visual additions
    use "hoob3rt/lualine.nvim"          -- Airline implementation in lua
    use "akinsho/bufferline.nvim"       -- Buffers and tabs status line

    -- Syntax
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "Glench/Vim-Jinja2-Syntax"      -- Jinja2 syntax support
    use "saltstack/salt-vim"            -- Support for saltstack(sls) filetype
    use "chr4/nginx.vim"                -- Support for nginx config filetype

    -- LSP and stuff
    use "neovim/nvim-lspconfig"         -- LSP configurations
    use "hrsh7th/nvim-cmp"              -- Completion engine
    use "hrsh7th/cmp-nvim-lsp"          -- Completions based on LSP
    use "hrsh7th/cmp-buffer"            -- Completions based on buffer
    use "hrsh7th/cmp-path"              -- Completions based on path
    use "hrsh7th/cmp-cmdline"           -- Completions based on command line
    use "hrsh7th/cmp-nvim-lua"          -- Completions for lua based config
    use "jose-elias-alvarez/null-ls.nvim" -- Adapter for formatters and linters
    use "folke/trouble.nvim"            -- Prettify LSP results
    use "ray-x/lsp_signature.nvim"      -- Show signatures

    -- Start screen
    use {
        "glepnir/dashboard-nvim",  -- Awesome dashboard
        requires = {'nvim-tree/nvim-web-devicons'}
    }
    use "ahmedkhalf/project.nvim"       -- Project management

    if autoinstalled then
        require("packer").sync()
    end
end)
