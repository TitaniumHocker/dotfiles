-- Extensions
vim.pack.add({
    "https://github.com/nvim-lua/popup.nvim",           -- Implementaion of popup API from Vim
    "https://github.com/nvim-lua/plenary.nvim",         -- Usefull lua functions for ext
    "https://github.com/kyazdani42/nvim-web-devicons",  -- Devicons for NeoVim

    -- Themes
    "https://github.com/sainnhe/gruvbox-material",      -- Old good gruvbox

    -- Tweaks
    "https://github.com/windwp/nvim-autopairs",         -- Autopairs, integrates with cmp and treesitter
    "https://github.com/folke/which-key.nvim",          -- Helps with commands
    "https://github.com/kyazdani42/nvim-tree.lua",      -- NerdTree implementation in lua
    "https://github.com/nvim-telescope/telescope.nvim", -- Awesome fuzzy finder
    "https://github.com/akinsho/toggleterm.nvim",       -- Nice tetminal
    "https://github.com/lewis6991/gitsigns.nvim",       -- Git integration
    "https://github.com/numToStr/Comment.nvim",         -- Comment things as Jedi

    -- Visual additions
    "https://github.com/hoob3rt/lualine.nvim",          -- Airline implementation in lua
    "https://github.com/akinsho/bufferline.nvim",       -- Buffers and tabs status line

    -- Syntax(treesitter)
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = 'main' },

    -- LSP and stuff
    "https://github.com/neovim/nvim-lspconfig",         -- LSP configurations
    "https://github.com/hrsh7th/nvim-cmp",              -- Completion engine
    "https://github.com/hrsh7th/cmp-nvim-lsp",          -- Completions based on LSP
    "https://github.com/hrsh7th/cmp-buffer",            -- Completions based on buffer
    "https://github.com/hrsh7th/cmp-path",              -- Completions based on path
    "https://github.com/hrsh7th/cmp-cmdline",           -- Completions based on command line
    "https://github.com/hrsh7th/cmp-nvim-lua",          -- Completions for lua based config
    "https://github.com/folke/trouble.nvim",            -- Prettify LSP results
    "https://github.com/ray-x/lsp_signature.nvim",      -- Show signatures
    "https://github.com/hedyhli/outline.nvim",          -- Code outline
})
