-- lua/plugin_configs.lua
-- NvimTree setup
require('nvim-tree').setup()

-- Setup other plugins
require('nvim-autopairs').setup{
    map_cr = false,
}
require('lualine').setup()
require "ibl".overwrite {
    exclude = { filetypes = {'markdown', 'json'} }
}

-- Go setup
require('go').setup()

-- Configure coc.nvim for Ansible
vim.g.coc_filetype_map = {
  ['yaml.ansible'] = 'ansible'
}
-- Configure coc.nvim for other filetypes
vim.g.coc_filetypes_enable = {'python', 'go', 'golang', 'yaml.ansible', 'terraform', 'tf'}
