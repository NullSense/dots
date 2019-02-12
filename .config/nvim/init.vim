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
    nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

    " Easymotion
    " to single leader instead of double
    map <Leader> <Plug>(easymotion-prefix)
    " follow next character
    nmap s <Plug>(easymotion-s)
    " follow 2 next characters
    nmap <Leader>s <Plug>(easymotion-s2)

    " Easily escape terminel
    tnoremap <leader><esc> <C-\><C-n><esc><cr>

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

    " Enter to complete
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

    " Use `[c` and `]c` for navigate diagnostics
    nmap <silent> [c <Plug>(coc-diagnostic-prev)
    nmap <silent> ]c <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K for show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if &filetype == 'vim'
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

"Vim general
set nocompatible
let g:gruvbox_italic=1
let vimtex_compiler_progname='nvr'
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

"Indentation
set autoindent
set smartindent
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
filetype plugin indent on

"Install plug
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin()
    Plug 'tpope/vim-fugitive'
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'mhinz/vim-startify'
    Plug 'ryanoasis/vim-devicons'
    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}} "intellisense engine
    "Plug 'tpope/vim-endwise' "pair matcher
    Plug 'easymotion/vim-easymotion' "move easier
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'morhetz/gruvbox'
    Plug 'lilydjwg/colorizer' "colorize hexcodes
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    Plug 'shime/vim-livedown'
    Plug 'scrooloose/nerdcommenter'
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
