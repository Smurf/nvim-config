-- lua/lsp_config.lua
--local nvim_lsp = require('lspconfig')

-- LSP Mappings (uses the global function from keymaps.lua)
local on_attach = function(client, bufnr)
  _G.on_attach_lsp_keymaps(bufnr) -- Call the global keymap function
  
  local opts = { noremap = true, silent = true, buffer = bufnr }
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
  end
end
-- Inlay hints setup
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, args.buf)
  end,
})

-- Configure LSP servers
-- Python
-- nvim_lsp.pyright.setup({
--   on_attach = on_attach
-- })

-- Golang
-- nvim_lsp.gopls.setup({
--   on_attach = function(client, bufnr)
--     on_attach(client, bufnr)
--     require("lsp-inlayhints").setup({
--       inlay_hints = {
--         parameter_hints = { prefix = "in: " },
--         type_hints = { prefix = "out: " }
--       }
--     })
--     require("lsp-inlayhints").on_attach(client, bufnr)
--   end,
--   settings = {
--     gopls = {
--       analyses = {
--         fieldalignment = false,
--         nilness = true,
--         unusedparams = true,
--         unusedwrite = true,
--         useany = true
--       },
--       codelenses = {
--         gc_details = false,
--         generate = true,
--         regenerate_cgo = true,
--         run_govulncheck = true,
--         test = true,
--         tidy = true,
--         upgrade_dependency = true,
--         vendor = true,
--       },
--       experimentalPostfixCompletions = true,
--       hints = {
--         assignVariableTypes = true,
--         compositeLiteralFields = true,
--         compositeLiteralTypes = true,
--         constantValues = true,
--         functionTypeParameters = true,
--         parameterNames = true,
--         rangeVariableTypes = true
--       },
--       gofumpt = true,
--       semanticTokens = true,
--       usePlaceholders = true,
--     }
--   }
-- })
-- 
-- Kubernetes YAML support using yaml-companion
vim.lsp.enable('terraformls')
vim.lsp.enable('pyright')
vim.lsp.enable('yamlls')
vim.lsp.enable('gopls')
