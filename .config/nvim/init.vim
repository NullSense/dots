"Mappings
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

"Vim general
set nocompatible
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

"Plugins
    call plug#begin()
    Plug 'ryanoasis/vim-devicons'
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
     function! Fzf_git_diff_files_with_dev_icons()
      let l:fzf_files_options = '--ansi --preview "sh -c \"(git diff --color=always -- {3..} | sed 1,4d; bat --color always --style numbers {3..}) | head -'.&lines.'\""'
       function! s:edit_devicon_prepended_file_diff(item)
        echom a:item
        let l:file_path = a:item[7:-1]
        echom l:file_path
        let l:first_diff_line_number = system("git diff -U0 ".l:file_path." | rg '^@@.*\+' -o | rg '[0-9]+' -o | head -1")
         execute 'silent e' l:file_path
        execute l:first_diff_line_number
      endfunction
       call fzf#run({
            \ 'source': 'git -c color.status=always status --short --untracked-files=all | devicon-lookup',
            \ 'sink':   function('s:edit_devicon_prepended_file_diff'),
            \ 'options': '-m ' . l:fzf_files_options,
            \ 'down':    '40%' })
    endfunction
     " Open fzf Files
    map <C-p> :call Fzf_files_with_dev_icons($FZF_DEFAULT_COMMAND)<CR>
    "map <C-d> :call Fzf_git_diff_files_with_dev_icons()<CR>
    "map <C-g> :call Fzf_files_with_dev_icons("git ls-files \| uniq")<CR>

"Theming
    set termguicolors "sets to true colors
    let &t_ut=''
    set background=dark
    let g:gruvbox_contrast_dark='soft'
    colorscheme gruvbox
