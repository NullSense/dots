set nocompatible
set background=dark
set encoding=utf-8 "windows specific rendering option

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
let g:airline_powerline_fonts = 1 "Fix airline font bug
set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1 "Windows specific rendering
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='gruvbox'

"GitGutter settings
let g:signify_vcs_list = [ 'git', 'hg' ] "git and mercurial
let g:signify_realtime = 1
let g:signify_sign_change = '~'

"Plug plugins
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-signify'
Plug 'jiangmiao/auto-pairs'
call plug#end()


let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
