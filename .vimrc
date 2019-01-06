let mapleader="\<Space>"
noremap <leader>y "+y

set nocompatible
set background=dark
set encoding=utf-8 "windows specific rendering option
set t_Co=256

"Vim general
set number "Number lines
set relativenumber
set hlsearch "highlight searches 
set incsearch "highlight while searching
set nowrapscan
set history=50
set autowrite
set ignorecase
set smartcase "only search case sensitive when a letter is capitalized

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

"Airline
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'


" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"GitGutter settings
let g:signify_vcs_list = [ 'git', 'hg' ] "git and mercurial
let g:signify_realtime = 1
let g:signify_sign_change = '~'

"Plug plugins
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-signify'
Plug 'jiangmiao/auto-pairs'
Plug 'Valloric/YouCompleteMe'
Plug 'suan/vim-instant-markdown'
call plug#end()

let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
