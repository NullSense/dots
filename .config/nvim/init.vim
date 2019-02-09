" Mappings
let mapleader="\<Space>"
noremap <leader>y "+y

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
map <M-l> :bn<CR>
map <M-h> :bprev<CR>
" Close buffer
map <M-d> :bd<CR>

" fzf Mappings
"fuzzy search lines
map <C-l> :Lines<CR>
"open file in subdirectories
map <C-p> :Files<CR>

set nocompatible
set encoding=utf-8 "windows specific rendering option

"Vim general
set number "Number lines
set relativenumber
set scrolloff=1
set hlsearch "highlight searches
set incsearch "highlight while searching
set inccommand=nosplit
set nowrapscan
set history=50
set autowrite
"set ignorecase
set smartcase "only search case sensitive when a letter is capitalized
"set listchars=tab:>·,trail:$,extends:>,precedes:<
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
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'lilydjwg/colorizer'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'Valloric/YouCompleteMe'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'scrooloose/nerdcommenter'
call plug#end()

set termguicolors "sets to true colors
let &t_ut=''
set background=dark
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
