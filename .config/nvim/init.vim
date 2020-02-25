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
"nnoremap <leader>r :%s/\V<c-r>=escape(expand('<cword>'), '\/')<cr>//g<left><left>

" Auto expand braces
"inoremap {<CR> {<C-o>o}<C-o>O

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
set tags=tags
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
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

"Install plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
if empty($SERVER) " Install these if not on a server
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    function! DisableExtras()
        call nvim_win_set_option(g:float_preview#win, 'number', v:false)
        call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
        call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
    endfunction

    autocmd User FloatPreviewWinOpen call DisableExtras()
    "set completeopt=menuone,preview,longest
    set completeopt-=preview

    let g:python3_host_prog = '/usr/bin/python3'
    let g:python2_host_prog = '/usr/bin/python2'
    Plug 'tpope/vim-repeat'
    Plug 'sheerun/vim-polyglot'
    Plug 'junegunn/fzf.vim'
    "Snippets
    let g:fzf_action = {
                \ 'ctrl-h': 'split',
                \ 'ctrl-v': 'vsplit'
                \ }
    nnoremap <c-o> :FZF<cr>
    nnoremap <leader>l :Rg<cr>
    Plug 'SirVer/ultisnips'
    let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
    Plug 'honza/vim-snippets'
    Plug 'airblade/vim-gitgutter'
    "Markdown
    Plug 'plasticboy/vim-markdown'
    Plug 'shime/vim-livedown'
    let g:livedown_autorun = 1
endif

Plug 'prabirshrestha/async.vim'
"Editorconfig
Plug 'editorconfig/editorconfig-vim'
Plug 'ap/vim-buftabline'
"Formatting
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
"Looks
Plug 'morhetz/gruvbox'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-rooter'
call plug#end()

nmap <C-m> :TagbarToggle<CR>


"Plugin settings
set updatetime=100 " gitgutter

"CoC
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <C-n> :CocCommand explorer<CR>
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>r <Plug>(coc-rename)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

"Theming
set termguicolors "sets to true colors
let &t_ut=''
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
