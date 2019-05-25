"Load file to last position of cursor
autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

"Custom linting
autocmd FileType python setlocal makeprg=pylint\ --output-format=parseable
"autocmd FileType latex setlocal makeprg=chktex\ --output-format=parseable
autocmd BufWritePost *.py silent make! <afile> | silent redraw!
"autocmd BufWritePost *.tex silent make! <afile> | silent redraw!
autocmd QuickFixCmdPost [^l]* cwindow

"Mappings
let mapleader="\<Space>"
noremap <leader>y "+y
nnoremap <leader>p VPY

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

"fzf Mappings
"Fuzzy search lines
nnoremap <C-o> :Lines<CR>
"Open file in subdirectories
nnoremap <C-p> :Files<CR>
"Open Buffers list
nnoremap <C-b> :Buffers<CR>

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
nnoremap <leader>r :%s/\V<c-r>=escape(expand('<cword>'), '\/')<cr>//g<left><left>

" Auto expand braces
inoremap {<CR> {<C-o>o}<C-o>O

" File manager
map <C-n> :Lexplore<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
" Tagbar toggle
nmap <C-m> :TagbarToggle<CR>


"Indentation
set autoindent
set smartindent
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
filetype plugin indent on

"Vim general
set nocompatible
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
"Completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
"Linting
"Plug 'w0rp/ale'
"Snippets
Plug 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
Plug 'honza/vim-snippets'
"Nerdtree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
"Fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
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
Plug 'ryanoasis/vim-devicons'
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
call plug#end()


"Plugin settings
set updatetime=100 " gitgutter

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Files + devicons
function! Fzf_files_with_dev_icons(command)
    let l:fzf_files_options = '--preview "bat --color always --style numbers {2..} | head -'.&lines.'"'
    function! s:edit_devicon_prepended_file(item)
        let l:file_path = a:item[4:-1]
        execute 'silent e' l:file_path
    endfunction
    call fzf#run({
                \ 'source': a:command.' | devicon-lookup',
                \ 'sink':   function('s:edit_devicon_prepended_file'),
                \ 'options': '-m ' . l:fzf_files_options,
                \ 'down':    '40%' })
endfunction
" Open fzf Files
map <C-p> :call Fzf_files_with_dev_icons($FZF_DEFAULT_COMMAND)<CR>

"Theming
set termguicolors "sets to true colors
let &t_ut=''
set background=dark
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
