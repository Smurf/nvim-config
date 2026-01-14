local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'kooparse/vim-color-desert-night'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    }
  }
  use 'windwp/nvim-autopairs'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  use 'lukas-reineke/indent-blankline.nvim'
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua'
  use 'miikanissi/modus-themes.nvim'
  -- Completion Engine
  use 'hrsh7th/nvim-cmp'         -- The main completion plugin
  use 'hrsh7th/cmp-nvim-lsp'     -- Connects LSP to nvim-cmp
  use 'hrsh7th/cmp-buffer'       -- Optional: Suggest words from the current buffer
  use 'hrsh7th/cmp-path'         -- Optional: Suggest file paths
  use 'hrsh7th/cmp-cmdline'      -- Optional: Autocomplete for command line
  use 'ray-x/lsp_signature.nvim' -- Optional: Type signatures after auto complete
  -- Snippet Engine (Required for nvim-cmp to work properly)
  use 'L3MON4D3/LuaSnip'         -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- Adapter for LuaSnip
  use 'rafamadriz/friendly-snippets' -- Pre-configured snippets for many languages
  -- Kubernetes support
--  use 'towolf/vim-helm'
--end )
--  use {
--     'someone-stole-my-name/yaml-companion.nvim',
--     requires = {
--       { 'neovim/nvim-lspconfig' },
--       { 'nvim-lua/plenary.nvim' },
--       { 'nvim-telescope/telescope.nvim' },
--     },
--     config = function()
--         require("telescope").load_extension("yaml_schema")
--     end,
--   }
end)
