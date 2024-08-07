-- so I don't need to source every time
vim.api.nvim_command('autocmd BufWritePost $MYVIMRC source %')

-- Show vim file open name in tmux
vim.cmd("autocmd BufReadPost,FileReadPost,BufNewFile * call system('tmux rename-window ' .. expand('%'))")

-- make preview window disappear after selection
vim.cmd("autocmd CursorMovedI * if pumvisible() == 0|pclose|endif")
vim.cmd("autocmd InsertLeave * if pumvisible() == 0|pclose|endif")

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.cmd('filetype plugin indent on')

-- Vim general
vim.opt.tags = 'tags'
vim.opt.cmdheight = 2
vim.opt.updatetime = 30
vim.opt.shortmess:append({ c = true })
vim.opt.signcolumn = 'yes'
vim.opt.autoread = true
vim.cmd('au CursorHold * checktime')
vim.opt.mouse = 'a'
vim.opt.encoding = 'UTF-8'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"
vim.opt.wrapscan = false
vim.opt.history = 50
vim.opt.autowrite = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.listchars = { tab = '>·', trail = '$', extends = '>', precedes = '<' }
vim.opt.list = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.completeopt = 'menuone,noselect'
vim.opt.shada = "!,'300,<50,s10,%"
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true
--vim.opt.shada = "'1000,!,<200,s1000,h,/100,'"
vim.cmd('syntax on') -- Syntax highlighting

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Mappings
vim.g.mapleader = ' '
-- Move through wrapped text easier
vim.api.nvim_set_keymap('n', 'j', 'gj', {})
vim.api.nvim_set_keymap('n', 'k', 'gk', {})

-- Clipboard remaps
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true })

-- Yank whole file
vim.keymap.set('n', '<leader>Y', 'gg"+yG', {})

-- Paste without replacing yank register
vim.keymap.set('v', '<leader>p', '"_dP', {})

-- Double esc to disable hlsearch
vim.keymap.set('n', '<Esc><Esc>', '<cmd>nohlsearch<CR><Esc>', { noremap = true })

-- Splits and Buffers
-- For easy split navigation (Ctrl + hjkl)
vim.keymap.set('n', '<C-j>', '<C-W><C-J>', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-W><C-K>', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-W><C-L>', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-W><C-H>', { noremap = true })

-- Resize splits
vim.keymap.set('n', '<S-Up>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<S-Down>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>', { silent = true })

-- Moving between buffers
vim.keymap.set('n', '<M-l>', ':bn<CR>', {})
vim.keymap.set('n', '<M-h>', ':bprev<CR>', {})

-- Close buffer
vim.keymap.set('n', '<M-d>', ':bp<Bar>bd #<CR>', { noremap = true, silent = true })

-- Move line up/down and align them
vim.keymap.set('n', '<leader>j', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==', { noremap = true, silent = true })
-- Same but for visual
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keeps search words centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- replace the word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make file +x
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- On insert and window unfocus, make line numbers non relative
vim.cmd([[
augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != 'i' | set rnu | endif
autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
]])

-- restore last cursor position
vim.cmd([[
augroup cursor
autocmd!
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
\ |   exe "normal! g`\""
\ | endif
augroup END
]])
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-------------
-- Plugins --
-------------
require("lazy").setup({
    "ellisonleao/gruvbox.nvim",
    "nvim-lualine/lualine.nvim",
    { "junegunn/fzf" },
    { "junegunn/fzf.vim" },
    {
        "ibhagwan/fzf-lua",
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { "preservim/tagbar",      keys = { { "<leader>t", "<cmd>TagbarToggle<cr>", desc = "TagBar" } } },
    { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },
    "mhinz/vim-signify",
    -- {
    --     "williamboman/mason.nvim",
    --     build = ":MasonUpdate" -- :MasonUpdate updates registry contents
    -- },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            --{ 'L3MON4D3/LuaSnip' },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "ray-x/lsp_signature.nvim" },
            { "ojroques/nvim-lspfuzzy" },
        }
    },
    "tpope/vim-repeat",
    "andymass/vim-matchup",
    "onsails/lspkind-nvim",
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = { { '<C-n>', '<cmd>NeoTreeShow<cr>', desc = "NeoTree" } },
        config = function()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
            require("neo-tree").setup({
                close_if_last_window = true,
                filesystem = {
                    filtered_items = { hide_dotfiles = false },
                    follow_current_file = true,
                },
            })
        end,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }
    },
    { "kevinhwang91/nvim-hlslens",   config = function() require("hlslens").setup {} end },
    "prabirshrestha/async.vim",
    "editorconfig/editorconfig-vim",
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "python", "javascript", "vim", "comment", "awk", "bash", "cmake", "css", "diff",
                "dockerfile", "dot", "gitconfig", "gitignore", "gitcommit", "gitattributes", "html", "json",
                "htmldjango", "http", "jq", "jsdoc", "json5", "lua", "luadoc", "markdown_inline", "regex", "rust", "sql",
                "todotxt", "typescript", "yaml" },
            auto_install = true,
            highlight = { enable = true },
            incremental_selection = { enable = true },
            indent = { enable = true },
            rainbow = { enable = true },
            autotag = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
            refactor = {
                highlight_definitions = { enable = true },
                highlight_current_scope = { enable = true },
                smart_rename = { enable = false },
            },
        },
        build = ':TSUpdate'
    },
    "romgrk/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-refactor",
    "machakann/vim-sandwich",
    { "norcalli/nvim-colorizer.lua", config = function() require("colorizer").setup {} end },
    { "windwp/nvim-autopairs",       config = function() require("nvim-autopairs").setup {} end },
    "plasticboy/vim-markdown",
    { "iamcco/markdown-preview.nvim", build = 'cd app & yarn install', dependencies = { "plasticboy/vim-markdown" } },
    "braxtons12/blame_line.nvim",
    {
        "szw/vim-maximizer",
        keys = {
            { "<leader>z", "<cmd>MaximizerToggle<cr>", desc = "Maximizer" },
        },
    },
})

vim.cmd('colorscheme gruvbox')

local lsp = require('lsp-zero').preset({})
-- lsp-zero
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
    vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)

    -- Diagnostics key mappings
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
    vim.keymap.set("n", "<leader>e", '<Cmd>LspDiagnostics 0<CR>', bufopts)

    lsp.buffer_autoformat()

    lsp.set_sign_icons({
        error = '',
        warn = '',
        hint = '',
        info = '»'
    })
end)
lsp.setup()

require("mason").setup()
require("lsp_signature").setup()
require("lspfuzzy").setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

local lspkind = require('lspkind')

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = {
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline" },
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'text_symbol',
        })
    }
})

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
require('ufo').setup()

-- fzf-lua
vim.keymap.set("n", "<C-\\>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
vim.keymap.set("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
vim.keymap.set("n", "<leader>l", [[<Cmd>lua require"fzf-lua".live_grep_glob()<CR>]], {})
vim.keymap.set("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
vim.keymap.set("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})
require("fzf-lua").utils.info(
    "|<C-\\> buffers|<C-p> files|<C-g> grep|<C-l> live grep|<C-k> builtin|<F1> help|")


-- local actions = require('fzf-lua').actions
require 'fzf-lua'.setup {
    keymap = {
        builtin = {
            ["<M-j>"] = "preview-page-down",
            ["<M-k>"] = "preview-page-up",
        },
    },
}
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
        lualine_b = { { 'branch', fmt = function(str) return str:sub(1, 7) end }, 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
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

local eslint = {
    lintCommand =
    "node_modules/.bin/eslint_d --ext .js,.jsx,.ts,.tsx,.json -c .eslintrc.js -f visualstudio --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    formatStdin = true,
    lintFormats = {
        "%f(%l,%c): %tarning %m",
        "%f(%l,%c): %rror %m"
    },
    lintSource = "eslint"
}

local prettier = { formatCommand = "node_modules/.bin/prettier" }
local isort = { formatCommand = "isort -rc -", formatStdin = true, lintFormats = { "%f:%l:%c: %m" } }
local flake8 = {
    lintCommand = "flake8 --max-line-length 100 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintSource = "flake8"
}

local black = { formatCommand = "black --fast -", formatStdin = true }

require('lspconfig').efm.setup {
    on_attach = on_attach,
    init_options = { documentFormatting = true, codeAction = true },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            javascript = { eslint, prettier },
            javascriptreact = { eslint, prettier },
            typescript = { eslint, prettier },
            typescriptreact = { eslint, prettier },
            python = { black, isort, flake8 }
        }
    },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "python" }
}

vim.g.python3_host_prog = '/usr/bin/python3'
