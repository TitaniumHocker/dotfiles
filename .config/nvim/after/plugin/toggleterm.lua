local loaded, toggleterm = pcall(require, "toggleterm")
if not loaded then return end
local Terminal  = require('toggleterm.terminal').Terminal
local key = require("ded.key")

toggleterm.setup {
    direction = "float",
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * .4
        end
    end,
}

local lazygit = Terminal:new({cmd = "lazygit", hidden = true, env = {FISH_NO_TMUX = "1"}})
function _lazygit_toggle()
  lazygit:toggle()
end

key.nmap("<C-t>", ":ToggleTerm<CR>")
key.tmap("<C-t>", "<C-\\><C-N>:ToggleTerm<CR>")
key.nmap("<leader>g", "<cmd>lua _lazygit_toggle()<CR>")
