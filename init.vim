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
set background=dark
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
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'ray-x/go.nvim'
    Plug 'ray-x/guihua.lua'
    Plug 'lvimuser/lsp-inlayhints.nvim'
    Plug 'miikanissi/modus-themes.nvim'
call plug#end()

colorscheme modus_vivendi
colorscheme desert-night
let mapleader = ' '
""let delimitMate_matchpairs = "(:),[:],{:}"
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

"CoC config
"Disable coc for all filetypes except the listed
let g:coc_filetypes_enable = ['python', 'go', 'golang', 'yaml.ansible']
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

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call CocActionAsync('showSignatureHelp')
    endif
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  "autocmd User CocJumpPlaceholder call CocActionAsync('doHover')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"
" -------------------- LSP Config ---------------------------------
:lua << EOF
  local nvim_lsp = require('lspconfig')
  function _G.check_back_space()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
  end
  -- LSP Mappings
  local mappings = function(client, bufnr)

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

  -- Inlay hints config
  vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
    vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
        if not (args.data and args.data.client_id) then
        return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
    })

  -- Server configs
  local servers = {'pyright', 'gopls'}
  nvim_lsp["pyright"].setup({on_attach = mappings})
  -- Golang Config
  nvim_lsp["gopls"].setup({
    on_attach = function(client, bufnr)
        mappings(client, bufnr)
        require("lsp-inlayhints").setup({
                inlay_hints = {
                parameter_hints = { prefix = "in: " }, -- "<- "
                type_hints = { prefix = "out: " }      -- "=> "
                }
            })
        require("lsp-inlayhints").on_attach(client,bufnr)
    end,
    settings = {
        gopls = {
            analyses = {
              fieldalignment = false, -- find structs that would use less memory if their fields were sorted
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            experimentalPostfixCompletions = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true
            },
            gofumpt = true,
            semanticTokens = true,
            usePlaceholders = true,
    }}
  })
-- golang config
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {
    require('go').setup()})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})
-- Run gofmt + goimports on save
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})
EOF
" -------------------- End LSP Config ------------------------------
"
" use <tab> for trigger completion and navigate to the next complete item
"
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

autocmd FileType yaml setlocal et ts=2 ai sw=2 nu sts=0

" Indentline Config
" Disable on markdown and json due to formatting issues
let g:indentLine_fileTypeExclude = ['markdown', 'json']

autocmd Filetype json
  \ let g:indentLine_setConceal = 0 

" FZF Settings
let g:fzf_vim = {}
nnoremap <leader><leader> :Files<CR>
nnoremap <leader>/ :BLines<CR>

" Golang config for filetype
" Set tab to 2 spaces
autocmd FileType go set shiftwidth=2
