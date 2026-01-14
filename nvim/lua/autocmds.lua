-- lua/autocmds.lua
-- Go format on save
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimports()
  end,
  group = format_sync_grp,
})

-- YAML and Ansible support
-- YAML file settings
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.{yaml,yml}",
  callback = function()
    vim.opt_local.filetype = "yaml"
    vim.opt_local.foldmethod = "indent"
  end
})

-- Ansible YAML detection
vim.api.nvim_create_autocmd("BufRead", {
  pattern = {"*/playbooks/*.yml", "*/playbooks/*.yaml", "*/roles/*.yml", "*/roles/*.yaml", "*/main.yaml", "*/tasks/*.yml", "*/tasks/*.yaml", "*ansible/*.yml", "*ansible/*.yaml"},
  callback = function()
    vim.opt_local.filetype = "yaml.ansible"
  end
})
