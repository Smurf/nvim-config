-- lua/lsp_config.lua
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
vim.api.nvim_set_hl(0, "LspInlayHint", {
    fg = "#FC8400", -- Replace with your desired foreground color (e.g., a muted gray)
    italic = true,    -- Optional: set text to italic
})
vim.api.nvim_create_autocmd("LspAttach", {
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
vim.lsp.config("terraformls", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"terraform"},
  cmd = {'terraform-ls', 'serve'}
})
-- Python
vim.lsp.config("basedpyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  cmd = {'basedpyright-langserver', '--stdio'}
})
-- YAML
vim.lsp.config("yamlls", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {'yaml-language-server', '--stdio'},
  filetypes = {'yaml'},
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
vim.lsp.enable('basedpyright')
vim.lsp.enable('yamlls')
require "lsp_signature".setup()
--vim.lsp.enable('gopls')
