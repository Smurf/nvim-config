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

-- Function to run yarn install for coc-ansible
local function install_coc_ansible()
  local coc_ansible_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/coc-ansible'
  if vim.fn.isdirectory(coc_ansible_path) ~= 0 then
    vim.fn.system('cd ' .. coc_ansible_path .. ' && yarn install --frozen-lockfile')
  end
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'kooparse/vim-color-desert-night'
  use {
    'neoclide/coc.nvim',
    branch = 'release'
  }
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
  use 'neovim/nvim-lspconfig'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
      'yaegassy/coc-ansible',
  }
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua'
  use 'lvimuser/lsp-inlayhints.nvim'
  use 'miikanissi/modus-themes.nvim'
  -- Kubernetes support
  use 'towolf/vim-helm'
--end )
  use {
     'someone-stole-my-name/yaml-companion.nvim',
     requires = {
       { 'neovim/nvim-lspconfig' },
       { 'nvim-lua/plenary.nvim' },
       { 'nvim-telescope/telescope.nvim' },
     },
     config = function()
         require("telescope").load_extension("yaml_schema")
     end,
   }
end)

-- Make install_coc_ansible available for autocmds
_G.install_coc_ansible = install_coc_ansible
