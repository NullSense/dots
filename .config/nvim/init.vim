"move through wrapped text easier
"nmap j gj
"nmap k gk

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
au CursorHold * checktime
set mouse=a
set encoding=utf-8 "windows specific rendering option
set undofile "persistent undo
set number "Number lines
set relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
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
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'liuchengxu/vista.vim'

    "let g:semshi#simplify_markup = v:true

    function MyCustomHighlights()
        "hi semshiLocal           ctermfg=209 guifg=#ff875f
        hi semshiLocal           ctermfg=209 guifg=#fe8019

        "hi semshiGlobal          ctermfg=214 guifg=#ffaf00
        "hi semshiImported        ctermfg=214 guifg=#ffaf00 cterm=bold gui=bold
        hi semshiGlobal          ctermfg=214 guifg=#fabd2f
        hi semshiImported        ctermfg=214 guifg=#d79921 cterm=bold gui=bold
         " This one? ^

        "hi semshiParameter       ctermfg=75  guifg=#5fafff
        hi semshiParameter       ctermfg=75  guifg=#458588

        "hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
        hi semshiParameterUnused ctermfg=117 guifg=#83a598 cterm=underline gui=underline

        "hi semshiFree            ctermfg=218 guifg=#ffafd7
        hi semshiFree            ctermfg=218 guifg=#b16286

        "i semshiBuiltin         ctermfg=207 guifg=#ff5fff
        hi semshiBuiltin         ctermfg=207 guifg=#d3869b

        "hi semshiAttribute       ctermfg=49  guifg=#00ffaf
        hi semshiAttribute       ctermfg=49  guifg=#689d6a

        hi semshiSelf            ctermfg=249 guifg=#b2b2b2
        "hi semshiUnresolved      ctermfg=226 guifg=#ffff00 cterm=underline gui=underline
        hi semshiUnresolved      ctermfg=226 guifg=#fabd2f cterm=underline gui=underline

        "hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f
        hi semshiSelected        ctermfg=231 guifg=#ebdbb2 ctermbg=161 guibg=#d3869b

        hi semshiErrorSign       ctermfg=231 guifg=#ebdbb2 ctermbg=160 guibg=#cc241d
        hi semshiErrorChar       ctermfg=231 guifg=#ebdbb2 ctermbg=160 guibg=#cc241d
        sign define semshiError text=E> texthl=semshiErrorSign
    endfunction
    autocmd FileType python call MyCustomHighlights()

    function! DisableExtras()
        call nvim_win_set_option(g:float_preview#win, 'number', v:false)
        call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
        call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
    endfunction

    autocmd User FloatPreviewWinOpen call DisableExtras()
    set completeopt-=preview

    let g:python3_host_prog = '/usr/bin/python3'
    let g:python2_host_prog = '/usr/bin/python2'
    Plug 'tpope/vim-repeat'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'pangloss/vim-javascript'
    Plug 'sheerun/vim-polyglot'
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-fugitive'
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
    Plug 'airblade/vim-gitgutter'

    "Markdown
    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    let g:livedown_autorun = 1
endif

Plug 'tmhedberg/SimpylFold'
Plug 'prabirshrestha/async.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-rooter'
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#vista#enabled = 1
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#branch#format = 1
 let g:airline#extensions#branch#displayed_head_limit = 8
let g:airline_extensions = ['hunks', 'branch', 'tabline', 'coc']

"let g:airline_section_x = ''
let g:airline_section_y = ''

set statusline^=%{coc#status()}
call plug#end()

"nmap <C-m> :TagbarToggle<CR>
nmap <C-m> :Vista!!<CR>

"Plugin settings
set updatetime=100 " gitgutter

"CoC
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <C-n> :CocCommand explorer --toggle --position=floating --floating-position=left-center --floating-width=60<CR>
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
nmap <silent> <leader>r <Plug>(coc-rename)
nmap <silent> <leader>a <plug>(coc-codeaction)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

"Theming
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let &t_ut=''
let g:gruvbox_contrast_dark='medium'
colorscheme gruvbox
