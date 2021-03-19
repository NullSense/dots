"move through wrapped text easier
nmap j gj
nmap k gk

"so I don't need to source every time
autocmd BufWritePost .vimrc source %

"Load file to last position of cursor
autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

"Show vim file open name in tmux
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

"make preview window dissapear after selection
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"Mappings
let mapleader="\<Space>"
"Clipboard remaps
nnoremap <leader>y "+y
vnoremap <leader>y "+y
"Yank whole file
nnoremap <leader>Y gg"+yG
"Paste without replacing yank register
vnoremap <leader>p "_dP

"Double esc to disable hlsearch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

"Splits and Buffers
"For easy split navigation (Ctrl + hjkl)
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

"Resize splits
nnoremap <silent> <s-up>    :resize +2<cr>
nnoremap <silent> <s-down>  :resize -2<cr>
nnoremap <silent> <s-left>  :vertical resize -2<cr>
nnoremap <silent> <s-right> :vertical resize +2<cr>
"Moving between buffers
nnoremap <M-l> :bn<CR>
nnoremap <M-h> :bprev<CR>
"Close buffer
nnoremap <M-d> :bp\|bd #<CR>

"Move line up/down
nnoremap <Leader>j ddp
nnoremap <Leader>k ddkP

"Indentation
set autoindent
set smartindent
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
filetype plugin indent on

"Vim general
highlight Comment cterm=italic
set tags=tags
"Better display for messages
set cmdheight=2
"You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=30
"don't give |ins-completion-menu| messages.
set shortmess+=c
"always show signcolumns
set signcolumn=yes
set autoread "reload file on change on disk
au CursorHold * checktime
set mouse=a
set encoding=utf-8 "windows specific rendering option
set undofile "persistent undo
set number
set relativenumber
augroup numbertoggle "no rel nums on non focused buffer
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set scrolloff=8
set hlsearch "highlight searches
set incsearch "highlight while searching
set inccommand=nosplit
set nowrapscan
set history=50
set autowrite
set ignorecase
set smartcase "only search case sensitive when a letter is capitalized
set listchars=tab:>·,trail:$,extends:>,precedes:<
set list "Shows invisible characters
set hidden "Show hidden buffers
syntax on "Syntax highlighting

"Sessions per folder
function! MakeSession(overwrite)
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  if a:overwrite == 0 && !empty(glob(b:filename))
    return
  endif
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
if(argc() == 0)
  au VimEnter * nested :call LoadSession()
  au VimLeave * :call MakeSession(1)
else
  au VimLeave * :call MakeSession(0)
endif

set ssop-=options "do not store global and local values in a session

"Install plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'szw/vim-maximizer'
    let g:maximizer_set_default_mapping = 0
    nnoremap <silent><leader>z :maximizertoggle<cr>
    vnoremap <silent><leader>z :maximizertoggle<cr>gv
    inoremap <silent><leader>z <c-o>:maximizertoggle<cr>

    Plug 'preservim/tagbar'
    nmap <Leader>t :TagbarToggle<CR>
    Plug 'neovim/nvim-lspconfig'
    Plug 'aca/pylance.nvim', { 'do': './install.sh' }
    Plug 'nvim-lua/completion-nvim'
    Plug 'mfussenegger/nvim-dap'
    Plug 'ThePrimeagen/vim-be-good'

    Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }
    nmap <Leader>as <Plug>(AerojumpSpace)
    nmap <Leader>ab <Plug>(AerojumpBolt)

    Plug 'vim-test/vim-test'
    nmap <silent> <Leader>tn :TestNearest<CR>
    nmap <silent> <Leader>tf :TestFile<CR>
    nmap <silent> <Leader>tl :TestLast<CR>

    let g:test#strategy = 'neovim'
    let test#python#runner = 'pytest'

    let test#python#pytest#options = {
                \ 'nearest': '--reuse-db --reruns 0 -n0 -fsvv',
                \ 'last':    '--reuse-db --reruns 0 -n0 -fsvv',
                \ 'file':    '--reuse-db --reruns 0 -n0 -fsvv --ff',
                \}

    if has('nvim') "normal mode terminal
      tmap <C-o> <C-\><C-n>
    endif

    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    set completeopt=menuone,noinsert,noselect
    set completeopt-=preview
    Plug 'mbbill/undotree'
    nnoremap <Leader>u :UndotreeToggle<CR>
    if has("persistent_undo")
        set undodir=$HOME"/.vim/undotree"
        set undofile
    endif
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-repeat'
    Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
    Plug 'junegunn/fzf.vim'
    Plug 'ojroques/nvim-lspfuzzy'
    let g:fzf_action = {
                \ 'ctrl-h': 'split',
                \ 'ctrl-v': 'vsplit'
                \ }
    nnoremap <c-p> :Files!<cr>
    nnoremap <leader>l :Rg!<cr>
    function! RipgrepFzf(query, fullscreen)
        let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always --smart-case -- %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
    "git gutter
    if has('nvim') || has('patch-8.0.902')
      Plug 'mhinz/vim-signify'
    else
      Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif

    "Markdown
    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    let g:livedown_autorun = 1

    Plug 'morhetz/gruvbox'
    "Theming
    if exists('+termguicolors')
      let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
    let &t_ut=''
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_italic=1
    let g:gruvbox_bold=1

    Plug 'ptzz/lf.vim'
    Plug 'voldikss/vim-floaterm'
    Plug 'blueyed/vim-diminactive'
    Plug 'camspiers/lens.vim'
    let g:lens#width_resize_min = 60
    let g:lens#width_resize_max = 100
    Plug 'kevinhwang91/nvim-hlslens'
    noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
                \<Cmd>lua require('hlslens').start()<CR>
    noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
                \<Cmd>lua require('hlslens').start()<CR>
    noremap * *<Cmd>lua require('hlslens').start()<CR>
    noremap # #<Cmd>lua require('hlslens').start()<CR>
    noremap g* g*<Cmd>lua require('hlslens').start()<CR>
    noremap g# g#<Cmd>lua require('hlslens').start()<CR>

    Plug 'prabirshrestha/async.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'romgrk/nvim-treesitter-context'
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'tpope/vim-surround'
    Plug 'tommcdo/vim-exchange'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'vim-airline/vim-airline'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    let g:airline#extensions#vista#enabled = 1
    let g:airline#extensions#coc#enabled = 0
    let g:airline#extensions#branch#format = 1
     let g:airline#extensions#branch#displayed_head_limit = 8
    let g:airline_extensions = ['hunks', 'branch', 'tabline', 'coc']
    let g:airline_section_y = ''
call plug#end()

colorscheme gruvbox

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  rainbow = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
  },
}

local lspconfig = require('lspconfig')

require 'pylance'
lspconfig.pylance.setup{
on_attach=require'completion'.on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        completeFunctionParens = true,
      }
    }
  }
}

--vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
require('lspfuzzy').setup {}
require('colorizer').setup()
EOF
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_enable_underline = 0
let g:diagnostic_auto_popup_while_jump = 1
let g:diagnostic_insert_delay = 1
"let g:python3_host_prog = '/usr/bin/python3'
"let g:python2_host_prog = '/usr/bin/python2'

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <Leader>D   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>w    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <Leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <Leader>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <Leader>aa <cmd>lua vim.lsp.buf.code_action()<CR>

"for diminactive
highlight ColorColumn ctermbg=0 guibg=#1d2021
