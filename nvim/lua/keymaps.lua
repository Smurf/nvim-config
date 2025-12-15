-- lua/keymaps.lua
-- NvimTree setup (replacement for NERDTree)
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Window movement mappings
vim.keymap.set('n', '<leader>k', '<C-w><Up>', { noremap = true })
vim.keymap.set('n', '<leader>j', '<C-w><Down>', { noremap = true })
vim.keymap.set('n', '<leader>l', '<C-w><Right>', { noremap = true })
vim.keymap.set('n', '<leader>h', '<C-w><Left>', { noremap = true })

-- LSP Mappings
local on_attach_lsp_keymaps = function(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

_G.on_attach_lsp_keymaps = on_attach_lsp_keymaps -- Make this accessible globally for lsp_config

-- Telescope (replacement for FZF) keybindings
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', telescope.find_files, {})
vim.keymap.set('n', '<leader>/', telescope.current_buffer_fuzzy_find, {})
