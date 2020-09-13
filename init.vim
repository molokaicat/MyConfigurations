call g:plug#begin()
"
" Julia
"
  Plug 'JuliaEditorSupport/julia-vim'
  Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
"  Plug 'roxma/nvim-completion-manager'  " optional NOTE: this plug in give me a Error detected while processing function <SNR>105_check_changes[21]..cm#snippet#check_and_inject:
  Plug 'neovim/nvim-lsp'
  Plug 'nvim-lua/diagnostic-nvim'                                    " better neovim built in lsp diagnostics
  Plug 'nvim-lua/completion-nvim'                                    " better neovim built in lsp completion

  "
  " Utility
  "
  Plug 'preservim/nerdtree'
  Plug 'jpalardy/vim-slime', { 'for': ['python', 'julia', 'sql']}
  Plug 'scrooloose/nerdcommenter'
  Plug 'sbdchd/neoformat'
  Plug 'neomake/neomake'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'tmhedberg/SimpylFold'
  Plug 'lervag/vimtex'
"  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
"  Plug 'prabirshrestha/async.vim'

  "
  " Spicey
  "
  Plug 'TroyFletcher/vim-colors-synthwave/'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  "
  " Python
  "
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': ['python', 'tex']}
  Plug 'zchee/deoplete-jedi', { 'for': ['python', 'tex']}
  Plug 'davidhalter/jedi-vim', { 'for': ['python', 'tex']}

  "
  " CoC
  "
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile', 'for': ['tex', 'python']}
  Plug 'fannheyward/coc-texlab', {'do': 'yarn install --frozen-lockfile', 'for': ['tex']}
  "

call g:plug#end()

set hidden " needed for rename

" Set indentation
syntax enable
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab


"julia
let g:default_julia_version = '1.4'
" language server
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
\   'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
\       using LanguageServer;
\       using Pkg;
\       import StaticLint;
\       import SymbolServer;
\       env_path = dirname(Pkg.Types.Context().env.project_file);
\
\       server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path, "");
\       server.runlinter = true;
\       run(server);
\   ']
\ }

nnoremap <silent>gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent><c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>K     <cmd>lua vim.lsp.buf.hover()<CR>

" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

autocmd BufEnter * lua require'completion'.on_attach()

lua << EOF
    local nvim_lsp = require'nvim_lsp'
    local on_attach_vim = function()
        require'diagnostic'.on_attach()
    end
    nvim_lsp.julials.setup({on_attach=on_attach_vim})
EOF

let g:diagnostic_auto_popup_while_jump = 0
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_enable_underline = 0
let g:completion_timer_cycle = 200 "default value is 80

" Slime (Vim) {{{
 "let g:slime_preserve_curpos = 0
   "let g:slime_target = "vimterminal"
   let g:slime_target = "tmux"
   let g:slime_no_mappings = 1
   xmap <leader>s <Plug>SlimeRegionSend
   nmap <leader>s <Plug>SlimeMotionSend
   nmap <Space> <Plug>SlimeLineSend
   "nnoremap <Space> <Plug>SlimeSend1
" }}}

" NERDtree {{{
   let g:NERDTreeWinPos = 'right'
   let g:NERDTreeQuitOnOpen = 1
   let g:NERDTreeMinimalMenu=1
" }}}

" Julia-Vim {{{
     let g:default_julia_version = "devel"
     let g:latex_to_unicode_eager = 0
     "let g:latex_to_unicode_auto = 1
     let g:latex_to_unicode_keymap = 1
     let g:julia_spellcheck_strings = 1
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

"
" Latex
"
let g:tex_flavor = 'latex'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" " Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
"
"" Avoid showing message extra message when using completion
set shortmess+=c"
" "

let g:vimtex_quickfix_mode=0
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_imaps_leader=1
let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'

" Tab through selection
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Neoformat
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

" Jedi-vim
" disable autocompletion, cause we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"

" NeoLint
let g:neomake_python_enabled_makers = ['pylint']
call neomake#configure#automake('nrwi', 500)

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" auto close window
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:airline_theme='laederon'
colorscheme synthwave
hi Normal guibg=NONE ctermbg=NONE

" to see spaces during typing
set listchars=eol:↲,tab:▶▹,extends:…,precedes:«,trail:•
set list
