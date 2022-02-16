local loaded, git = pcall(require, "gitsigns")
if not loaded then return end

git.setup {}
