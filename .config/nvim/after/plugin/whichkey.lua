local loaded, whichkey = pcall(require, "which-key")
if not loaded then return end

whichkey.setup()
