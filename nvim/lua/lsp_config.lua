-- lua/lsp_config.lua
--local nvim_lsp = require('lspconfig')
-- ADD THIS: Set up completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP Mappings
local on_attach = function(client, bufnr)
  if _G.on_attach_lsp_keymaps then
    _G.on_attach_lsp_keymaps(bufnr)
  end
  local opts = { noremap = true, silent = true, buffer = bufnr }
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
  end
end

-- Inlay hints setup
-- Native Inlay hints setup (Neovim 0.10+)
vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Check if the server supports inlay hints
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
-- Configure LSP servers

-- Terraform
--nvim_lsp.terraformls.setup({
--  on_attach = on_attach,
--})
vim.lsp.config("terraformls", {
  on_attach = on_attach,
  capabilities = capabilities,
})
-- Python
--nvim_lsp.pyright.setup({
--  on_attach = on_attach,
--})
vim.lsp.config("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
})
-- YAML
--nvim_lsp.yamlls.setup({
--  on_attach = on_attach,
--  settings = {
--    yaml = {
--      -- This helps with Kubernetes files
--      schemas = {
--        kubernetes = "*.yaml",
--        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
--        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
--        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
--      },
--    },
--  },
--})
vim.lsp.config("yamlls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      -- This helps with Kubernetes files
      schemas = {
        kubernetes = "*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      },
    },
  },
})
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
--vim.lsp.enable('gopls')
