-- Base (Neo)Vim options
vim.opt.relativenumber = true      -- Show relative line numbers
vim.opt.clipboard = "unnamedplus"  -- Universal clipboard
vim.opt.cmdheight = 2              -- 2 lines for commands line
vim.opt.hlsearch = true            -- Highlight search matches
vim.opt.ignorecase = true          -- Case insensetive search
vim.opt.smartcase = true           -- Turn off 'ignorecase' if pattern contains upper signs
vim.opt.expandtab = true           -- Expand <Tab> to spaces
vim.opt.shiftwidth = 4             -- 1 tab = 4 spaces for autoindent
vim.opt.tabstop = 4                -- 1 tab = 4 spaces for <Tab>
vim.opt.smartindent = true         -- Make autoindent smarter
vim.opt.showtabline = 2            -- Always show tabs
vim.opt.hidden = true              -- Keep unsaved buffers in the background
vim.opt.wrap = true                -- Force lines wrapping
vim.opt.scrolloff = 4              -- Scrolling padding
vim.opt.errorbells = false         -- Fuck this shit
vim.opt.colorcolumn = "80"         -- Show column at 80
vim.opt.pumheight = 8              -- PopUpMenu height
vim.opt.signcolumn = "yes"         -- Always show sign column
vim.opt.cursorline = true          -- Show cursor line
vim.opt.exrc = true                -- Source .nvimrc, .vimrc and .exrc in CWD
vim.opt.secure = true              -- Disable 'exrc' if files not owned by you
vim.opt.updatetime = 300           -- Short updatetime increases user experience, default is 4k
vim.opt.undofile = true            -- Keep history for undo operation
vim.opt.shortmess:append "c"       -- Don't pass messages to completion menu
vim.cmd "set formatoptions-=o"     -- Don't insert comment leader after 'o' or 'O' in normal mode
vim.cmd "set ww+=<,>,[,],h,l"      -- Update wrapping options(whichwrap)
vim.cmd "set iskeyword+=-"         -- Don't separate words by '-' sign
vim.opt.completeopt = {            -- For nvim-cmp:
    "menuone",                     --  - show menu even if there is only one match
    "noselect",                    --  - don't autoselect match
    "noinsert"                     --  - don't autoinsert value from match
}