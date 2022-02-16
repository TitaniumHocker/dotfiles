local loaded, toggleterm = pcall(require, "toggleterm")
if not loaded then return end

toggleterm.setup {
    direction = "float",
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * .4
        end
    end,
    open_mapping = [[<c-\>]],
}
