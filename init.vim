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


call plug#begin('~/.local/share/nvim/plugged')
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
call plug#end()

colorscheme desert-night

let delimitMate_matchpairs = "(:),[:],{:}"

"NERD Tree settings
"stop nerdtreetabs from opening every time you switch tabs
let g:nerdtree_tabs_open_on_new_tab = 0
"NERD Tree mappings
nnoremap _n :NERDTreeMirrorToggle<CR>

" Map ctrl-movement keys to window switching
nnoremap <C-k> <C-w><Up>
nnoremap <C-j> <C-w><Down>
nnoremap <C-l> <C-w><Right>
nnoremap <C-h> <C-w><Left>

"YAML config
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
"Close popups for auto complete
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

autocmd FileType yaml setlocal et ts=2 ai sw=2 nu sts=0


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
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
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
let g:my_coc_file_types = ['c', 'cpp', 'h', 'asm', 'hpp', 'vim', 'sh', 'py']

function! s:disable_coc_for_type()
	if index(g:my_coc_file_types, &filetype) == -1
	        let b:coc_enabled = 0
	endif
endfunction

augroup CocGroup
	autocmd!
	autocmd BufNew,BufEnter * call s:disable_coc_for_type()
augroup end

" YAML files
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
"Close popups for auto complete
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

autocmd FileType yaml setlocal et ts=2 ai sw=2 nu sts=0
let g:indentLine_fileTypeExclude = ['markdown', 'json']
