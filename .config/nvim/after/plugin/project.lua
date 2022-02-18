local loaded, project = pcall(require, "project_nvim")
if not loaded then return end

project.setup {}

local loaded, telescope = pcall(require, "telescope")
if not loaded then return end

telescope.load_extension("projects")
