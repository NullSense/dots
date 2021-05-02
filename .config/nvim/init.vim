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

function! QuickFixOpenAll()
  if empty(getqflist())
    return
  endif
  let modifier = "tabe"
  let s:prev_val = ""
  for d in getqflist()
    let s:curr_val = bufname(d.bufnr)
    if (s:curr_val != s:prev_val)
      exec modifier." " . s:curr_val
      let modifier = 'vert sb'
    endif
    let s:prev_val = s:curr_val
  endfor
endfunction

command! QuickFixOpenAll call QuickFixOpenAll()
nnoremap <leader>oa :QuickFixOpenAll<cr>

"Mappings
let mapleader="\<Space>"
"Clipboard remaps
nnoremap <leader>y "+y
vnoremap <leader>y "+y
"Yank whole file
nnoremap <leader>Y gg"+yG
"Paste without replacing yank register
vnoremap <leader>p "_dP

"Double esc to disable hlsearch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

"Splits and Buffers
"For easy split navigation (Ctrl + hjkl)
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

"Resize splits
nnoremap <silent> <s-up>    :resize +2<cr>
nnoremap <silent> <s-down>  :resize -2<cr>
nnoremap <silent> <s-left>  :vertical resize -2<cr>
nnoremap <silent> <s-right> :vertical resize +2<cr>
"Moving between buffers
nnoremap <M-l> :bn<CR>
nnoremap <M-h> :bprev<CR>
"Close buffer
nnoremap <M-d> :bp\|bd #<CR>

"Move line up/down
nnoremap <Leader>j ddp
nnoremap <Leader>k ddkP

"Indentation
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
filetype plugin indent on

"Vim general
highlight Comment cterm=italic
set tags=tags
"Better display for messages
set cmdheight=2
"You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=30
"don't give |ins-completion-menu| messages.
set shortmess+=c
"always show signcolumns
set signcolumn=yes
set autoread "reload file on change on disk
au CursorHold * checktime
set mouse=a
set encoding=utf-8 "windows specific rendering option
set number
set relativenumber
augroup numbertoggle "no rel nums on non focused buffer
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set scrolloff=8
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

"Sessions per folder
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
if(argc() == 0)
  au VimEnter * nested :call LoadSession()
endif

au VimLeave * :call MakeSession()

"set ssop-=options "do not store global and local values in a session

"Install plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'szw/vim-maximizer'
    let g:maximizer_set_default_mapping = 0
    nnoremap <silent><leader>z :MaximizerToggle<cr>
    vnoremap <silent><leader>z :MaximizerToggle<cr>gv
    inoremap <silent><leader>z <c-o>:MaximizerToggle<cr>

    Plug 'preservim/tagbar'
    nmap <Leader>t :TagbarToggle<CR>
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'
    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <CR>      compe#confirm('<CR>')
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
    if has('nvim') "normal mode terminal
      tmap <C-o> <C-\><C-n>
    endif

    "inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    "inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    set completeopt=menuone,noselect
    Plug 'mbbill/undotree'
    nnoremap <Leader>u :UndotreeToggle<CR>
    set undofile
    set undodir=$HOME"/.vim/undotree"
    set undolevels=1000
    set undoreload=10000
    Plug 'tpope/vim-repeat'
    Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
    Plug 'junegunn/fzf.vim'
    Plug 'ojroques/nvim-lspfuzzy'
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
    "git gutter
    Plug 'mhinz/vim-signify'

    "Markdown
    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    let g:livedown_autorun = 1

    Plug 'morhetz/gruvbox'
    Plug 'folke/lsp-colors.nvim'
    Plug 'onsails/lspkind-nvim'
    "Theming
    if exists('+termguicolors')
      let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
    let &t_ut=''
    set background=dark
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_italic=1
    let g:gruvbox_bold=1

    Plug 'preservim/nerdtree'
    nnoremap <C-t> :NERDTreeFind<CR>
    Plug 'voldikss/vim-floaterm'
    Plug 'blueyed/vim-diminactive'
    Plug 'camspiers/lens.vim'
    let g:lens#width_resize_min = 60
    let g:lens#width_resize_max = 100
    Plug 'kevinhwang91/nvim-hlslens'
    noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
                \<Cmd>lua require('hlslens').start()<CR>
    noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
                \<Cmd>lua require('hlslens').start()<CR>
    noremap * *<Cmd>lua require('hlslens').start()<CR>
    noremap # #<Cmd>lua require('hlslens').start()<CR>
    noremap g* g*<Cmd>lua require('hlslens').start()<CR>
    noremap g# g#<Cmd>lua require('hlslens').start()<CR>

    Plug 'prabirshrestha/async.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'romgrk/nvim-treesitter-context'
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'tmsvg/pear-tree'
    let g:pear_tree_smart_openers = 1
    let g:pear_tree_smart_closers = 1
    let g:pear_tree_smart_backspace = 1
    " Disable automapping so we can fix Coc mapping.
    let g:pear_tree_map_special_keys = 0

    " Default mappings:
    imap <BS> <Plug>(PearTreeBackspace)
    imap <Esc> <Plug>(PearTreeFinishExpansion)
    " Get PearTreeExpand working with coc.nvim
    imap <expr> <CR> pumvisible() ? compe#confirm('<CR>') : "\<Plug>(PearTreeExpand)"
    Plug 'tpope/vim-surround'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'vim-airline/vim-airline'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    let g:airline#extensions#vista#enabled = 1
    let g:airline#extensions#coc#enabled = 0
    let g:airline#extensions#branch#format = 1
     let g:airline#extensions#branch#displayed_head_limit = 8
    let g:airline_extensions = ['hunks', 'branch', 'tabline', 'coc']
    let g:airline_section_y = ''
call plug#end()

colorscheme gruvbox

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,               -- false will disable the whole extension
  },
  rainbow = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    smart_rename = { enable = false },
  },
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    treesitter = true;
    tags = true;
    spell = true;
    calc = true;
  };
}

local on_attach = function(client)
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[augroup lsp_formatting]]
    vim.cmd [[autocmd!]]
    vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync({},1000)]]
    vim.cmd [[augroup END]]
  end
end

require('lspfuzzy').setup {}
require('colorizer').setup{}

--require'lspconfig'.pyright.setup{}
require'lspconfig'.html.setup{
    init_options = {
        configurationSection = { "html" },
        embeddedLanguages = {
            css = true,
            javascript = true
        }
    }
}
require"lspconfig".cssls.setup {on_attach = on_attach}
require"lspconfig".bashls.setup {on_attach = on_attach}
require"lspconfig".dockerls.setup {on_attach = on_attach}
require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
require"lspconfig".yamlls.setup {on_attach = on_attach}

require"lspconfig".tsserver.setup {
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
  end
}

local eslint = {
    lintCommand = "node_modules/.bin/eslint_d --ext .js,.jsx,.ts,.tsx -c .eslintrc.js -f visualstudio --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    foratStdin= true,
    lintFormats = {
        "%f(%l,%c): %tarning %m",
        "%f(%l,%c): %rror %m"
    },
    lintSource = "eslint"
}

local prettier = {
    formatCommand = "node_modules/.bin/prettier"
}

local isort = {
    formatCommand = "isort -rc -",
    formatStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
}

local flake8 = {
    lintCommand = "flake8 --max-line-length 100 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintSource = "flake8"
}

local black = {
    formatCommand = "black --fast -",
    formatStdin = true
}

require "lspconfig".efm.setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            javascript = {eslint},
            javascriptreact = {eslint},
            typescript = {eslint},
            typescriptreact = {eslint},
            python = {black, isort, flake8},
        }
    },
    filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact", "python"},
}


require("lspkind").init(
    {
        with_text = true,
        symbol_map = {
            Folder = ""
        }
    }
)

EOF
highlight link CompeDocumentation NormalFloat
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_enable_underline = 0
let g:diagnostic_auto_popup_while_jump = 1
let g:diagnostic_insert_delay = 1
let g:python3_host_prog = '/usr/bin/python3'
let g:python2_host_prog = '/usr/bin/python2'

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gI    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <Leader>D   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>w    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <Leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <Leader>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <Leader>aa <cmd>lua vim.lsp.buf.code_action()<CR>

"for diminactive
highlight ColorColumn ctermbg=0 guibg=#1d2021
