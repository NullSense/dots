" Mappings
let mapleader="\<Space>"
noremap <leader>y "+y

" Double esc to disable hlsearch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Splits and Buffers
" For easy split navigation (Ctrl + hjkl)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Resize splits
nnoremap <silent> <s-up>    :resize +2<cr>
nnoremap <silent> <s-down>  :resize -2<cr>
nnoremap <silent> <s-left>  :vertical resize -2<cr>
nnoremap <silent> <s-right> :vertical resize +2<cr>
" Moving between buffers
nnoremap <M-l> :bn<CR>
nnoremap <M-h> :bprev<CR>
" Close buffer
nnoremap <M-d> :bd<CR>

"fzf Mappings
"Fuzzy search lines
nnoremap <C-o> :Lines<CR>
"Open file in subdirectories
nnoremap <C-p> :Files<CR>

" Increment numbers
noremap + <c-a>
noremap - <c-x>

" Move line up/down
nnoremap <Leader>j ddp
nnoremap <Leader>k ddkP
" Easy indentation
nnoremap <Leader>h <<
nnoremap <Leader>l >>

" Search and replace occurences of word under cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Easymotion
" to single leader instead of double
map <Leader> <Plug>(easymotion-prefix)
" follow next character
nmap s <Plug>(easymotion-s)
" follow 2 next characters
nmap <Leader>s <Plug>(easymotion-s2)

set nocompatible
set encoding=utf-8 "windows specific rendering option

"Vim general
set undofile "persistent undo
set number "Number lines
set relativenumber
set scrolloff=1
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

" Indentation
set autoindent
set smartindent
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
filetype plugin indent on

syntax on "Syntax highlighting

set updatetime=10

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

call plug#begin()
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}} "intellisense engine
Plug 'tpope/vim-endwise' "pair matcher
Plug 'easymotion/vim-easymotion' "move easier
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'lilydjwg/colorizer' "colorize hexcodes
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdcommenter'
call plug#end()

set termguicolors "sets to true colors
let &t_ut=''
set background=dark
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
