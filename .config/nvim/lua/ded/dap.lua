local loaded, dap = pcall(require, "dap")
if not loaded then return end

local key = require("ded.key")

nmap("<leader>dc", "<cmd>lua require('dap').continue()<CR>")
nmap("<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
nmap("<leader>ds", "<cmd>lua require('dap').step_over()<CR>")
nmap("<leader>di", "<cmd>lua require('dap').step_into()<CR>")
