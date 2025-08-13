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

-- Run yarn install for coc-ansible after Packer syncs
vim.api.nvim_create_autocmd("User", {
  pattern = "PackerComplete",
  callback = _G.install_coc_ansible -- Call the global function
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
  pattern = {"*/playbooks/*.yml", "*/playbooks/*.yaml", "*/roles/*.yml", "*/roles/*.yaml", "*/main.yaml", "*/tasks/*.yml", "*/tasks/*.yaml"},
  callback = function()
    vim.opt_local.filetype = "yaml.ansible"
  end
})

-- CocEnable/Disable based on filetype
vim.api.nvim_create_autocmd({"BufNew", "BufEnter", "BufAdd", "BufCreate"}, {
  callback = function()
    local ft = vim.bo.filetype
    if vim.tbl_contains(vim.g.coc_filetypes_enable, ft) then
      vim.cmd('CocEnable')
    else
      vim.cmd('CocDisable')
    end
  end
})
