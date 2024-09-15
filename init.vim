set termguicolors
set nu! 
set incsearch
set tabstop=2
set smarttab
set shiftround
set nojoinspaces
set shiftwidth=4
set expandtab
set guifont=Source\ Code\ Pro\ 12
set nofoldenable
set mouse=
"stop nerdtree from popping open every file open
set switchbuf=useopen,usetab

syntax on

let g:nvim_system_wide = 0
if g:nvim_system_wide
    let g:PLUGIN_HOME="/usr/local/share/nvim/site"
else
    let g:PLUGIN_HOME=expand(stdpath('data') . '/plugged')
endif

call plug#begin(g:PLUGIN_HOME)
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'kooparse/vim-color-desert-night'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'Raimondi/delimitMate'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mrk21/yaml-vim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'mrk21/yaml-vim'
    Plug 'Yggdroot/indentLine'
    Plug 'yaegassy/coc-ansible', {'do': 'yarn install --frozen-lockfile'}
call plug#end()

colorscheme desert-night
let mapleader = ' '
let delimitMate_matchpairs = "(:),[:],{:}"
"NERD Tree settings
"stop nerdtreetabs from opening every time you switch tabs
let g:nerdtree_tabs_open_on_new_tab = 0
"NERD Tree mappings
nnoremap <leader>n :NERDTreeMirrorToggle<CR>

" Map ctrl-movement keys to window switching
nnoremap <leader>k <C-w><Up>
nnoremap <leader>j <C-w><Down>
nnoremap <leader>l <C-w><Right>
nnoremap <leader>h <C-w><Left>

"YAML config
"Close popups for auto complete
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" -------------------- LSP ---------------------------------
:lua << EOF
  local nvim_lsp = require('lspconfig')
  function _G.check_back_space()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
  end
  local on_attach = function(client, bufnr)

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

  end

  local servers = {'pyright'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF
" -------------------- LSP ---------------------------------
"
" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ v:lua.check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <S-Tab>
      \ pumvisible() ? "\<C-p>" :
      \ v:lua.check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"Disable coc for all filetypes except the listed
let g:coc_filetypes_enable = ['python', 'yaml.ansible']
function! s:disable_coc_for_type()
  if index(g:coc_filetypes_enable, &filetype) == -1
    :silent! CocDisable
  else
    :silent! CocEnable
  endif
endfunction

augroup CocGroup
 autocmd!
 autocmd BufNew,BufEnter,BufAdd,BufCreate * call s:disable_coc_for_type()
augroup end

" YAML files
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal et ts=2 ai sw=2 nu sts=0

au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */playbooks/*.yaml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*.yaml set filetype=yaml.ansible
let g:coc_filetype_map = {
  \ 'yaml.ansible': 'ansible',
  \ }

"Close popups for auto complete
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

autocmd FileType yaml setlocal et ts=2 ai sw=2 nu sts=0

" Indentline Config
let g:indentLine_fileTypeExclude = ['markdown', 'json']

autocmd Filetype json
  \ let g:indentLine_setConceal = 0 

" FZF Settings
let g:fzf_vim = {}
nnoremap <leader><leader> :Files<CR>
nnoremap <leader>/ :BLines<CR>
