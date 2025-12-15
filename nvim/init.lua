-- init.lua
vim.lsp.set_log_level("debug")
-- Set vim options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.joinspaces = false
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.guifont = "Hack Nerd Font Mono:h12"
vim.opt.foldenable = false
vim.opt.mouse = ""
vim.opt.switchbuf = "useopen,usetab"
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Plugin management with Packer
require('packer_setup')

-- Require other configuration files
require('keymaps')
require('lsp_config')
require('plugin_configs')
require('autocmds')
require('completion')

-- Color scheme (can also be in plugin_configs if tied to a plugin)
vim.cmd([[
colorscheme desert-night
]])
--  colorscheme modus_vivendi
