"move through wrapped text easier
nmap j gj
nmap k gk

"so I don't need to source every time
autocmd BufWritePost .vimrc source %

autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.py.in lua vim.lsp.buf.formatting_sync(nil, 1000)

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
set encoding=UTF-8 "windows specific rendering option
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
    Plug 'dstein64/vim-startuptime'
    nmap <Leader>t :TagbarToggle<CR>
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'ray-x/lsp_signature.nvim'
    set completeopt=menuone,noselect
    Plug 'tpope/vim-repeat'
    Plug 'andymass/vim-matchup'
    Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
    Plug 'junegunn/fzf.vim'
    Plug 'ojroques/nvim-lspfuzzy'
    Plug 'APZelos/blamer.nvim'
    let g:blamer_enabled = 1
    let g:blamer_delay = 300
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

    Plug 'ellisonleao/gruvbox.nvim'
    Plug 'folke/lsp-colors.nvim'
    Plug 'onsails/lspkind-nvim'
    "Theming
    set termguicolors
    set background=dark
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_italic=1
    let g:gruvbox_bold=1

    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'
    nnoremap <C-n> :NvimTreeToggle<CR>
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
    Plug 'tpope/vim-surround'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'windwp/nvim-autopairs'
    "Plug 'vim-airline/vim-airline'
    "let g:airline_powerline_fonts = 1
    "let g:airline#extensions#hunks#non_zero_only = 1
    "let g:airline#extensions#tabline#formatter = 'unique_tail'
    "let g:airline#extensions#coc#enabled = 0
    "let g:airline#extensions#branch#format = 1
     "let g:airline#extensions#branch#displayed_head_limit = 8
    "let g:airline_extensions = ['hunks', 'branch', 'tabline']
    "let g:airline_section_y = ''
call plug#end()

colorscheme gruvbox


lua <<EOF
require('nvim-autopairs').setup{}
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1,1) end }
      },
    lualine_b = {
      { 'branch', fmt = function(str) return str:sub(1,7) end }, 'diff', 'diagnostics'
      },
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_c = {'filename'},
    lualine_x = {'location'},
  },
  tabline = {
      lualine_a = {
    {
      'buffers',
      show_filename_only = true,   -- Shows shortened relative path when set to false.
      show_modified_status = true, -- Shows indicator when the buffer is modified.
    }
  }
  },
}
require "lsp_signature".setup()
local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
    })
  }
}

require'nvim-tree'.setup {
}

require'nvim-treesitter.configs'.setup {
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

require'lspconfig'.pyright.setup{}
require'lspconfig'.html.setup{
    init_options = {
        configurationSection = { "html" },
        embeddedLanguages = {
            css = true,
            javascript = true
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

EOF
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
