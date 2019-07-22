"Load file to last position of cursor
autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

"Show vim file open name in tmux
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

"Mappings
let mapleader="\<Space>"
noremap <leader>y "+y

" Double esc to disable hlsearch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Splits and Buffers
" For easy split navigation (Ctrl + hjkl)
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

" Resize splits
nnoremap <silent> <s-up>    :resize +2<cr>
nnoremap <silent> <s-down>  :resize -2<cr>
nnoremap <silent> <s-left>  :vertical resize -2<cr>
nnoremap <silent> <s-right> :vertical resize +2<cr>
" Moving between buffers
nnoremap <M-l> :bn<CR>
nnoremap <M-h> :bprev<CR>
" Close buffer
nnoremap <M-d> :bp\|bd #<CR>

" Move line up/down
nnoremap <Leader>j ddp
nnoremap <Leader>k ddkP

" Search and replace occurences of word under cursor
nnoremap <leader>r :%s/\V<c-r>=escape(expand('<cword>'), '\/')<cr>//g<left><left>

" Auto expand braces
inoremap {<CR> {<C-o>o}<C-o>O

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
let g:gruvbox_italic=1
let g:gruvbox_bold=1
set autoread "reload file on change on disk
set mouse=a
set encoding=utf-8 "windows specific rendering option
set undofile "persistent undo
set number "Number lines
set relativenumber
set scrolloff=3
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

"remove whitespaces at end of lines on save
"autocmd BufWritePre * %s/\s\+$//e

"Install plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
"Editorconfig
Plug 'editorconfig/editorconfig-vim'
"Completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
"python doeplete
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'neovim/pynvim'
Plug 'davidhalter/jedi'

set completeopt=menuone,preview,longest

let g:ale_python_pylint_options = '--load-plugins pylint_django'
let g:python3_host_prog = '/usr/bin/python3'
let g:python2_host_prog = '/usr/bin/python2'
let g:deoplete#sources#jedi#show_docstring = 1
Plug 'tpope/vim-repeat'
"Linting
Plug 'w0rp/ale'
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fixers = {
 \ 'javascript': ['eslint'],
 \ 'python': ['isort', 'yapf', 'autopep8']
 \ }
let g:ale_linters = {
 \ 'javascript': ['eslint']
 \ }
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>ap :ALEPreviousWrap<cr>
Plug 'sheerun/vim-polyglot'
"Snippets
Plug 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
Plug 'honza/vim-snippets'
"Formatting
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
"Looks
Plug 'morhetz/gruvbox'
Plug 'lilydjwg/colorizer' "colorize hexcodes
"Git
Plug 'airblade/vim-gitgutter'
"Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Markdown
Plug 'plasticboy/vim-markdown'
Plug 'shime/vim-livedown'
"Latex
Plug 'lervag/vimtex', { 'for': 'tex' }
let vimtex_compiler_progname='nvr'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
autocmd FileType plaintex,tex,latex setlocal spell "spell check for latex
set spelllang=en_gb "spell check language
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" Web dev
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'javascript.jsx',
                \ 'vue',
                \ '...'
                \ ]
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']
Plug 'othree/jspc.vim'
Plug 'scrooloose/nerdtree'
" Tabularize
Plug 'godlygeek/tabular'
if exists(":Tabularize")
      nmap <Leader>t= :Tabularize /=<CR>
      vmap <Leader>t= :Tabularize /=<CR>
      nmap <Leader>t: :Tabularize /:\zs<CR>
      vmap <Leader>t: :Tabularize /:\zs<CR>
    endif
call plug#end()

map <C-n> :NERDTreeToggle<CR>

"Plugin settings
set updatetime=100 " gitgutter

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"Theming
set termguicolors "sets to true colors
let &t_ut=''
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
