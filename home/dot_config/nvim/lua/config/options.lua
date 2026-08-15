vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused language providers (no plugins need them; quiets :checkhealth)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 8
opt.updatetime = 250
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
