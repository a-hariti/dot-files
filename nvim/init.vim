set nobackup
set nowritebackup
set updatetime=300
set signcolumn=number
set expandtab
set softtabstop =4
set shiftwidth  =4
set shiftround
set hidden
set incsearch
set ignorecase
set smartcase
set hlsearch
set lazyredraw
set shortmess+=c

set splitbelow
set splitright

set cursorline
set noshowmode "redundant with a status line

set list " show white space
set listchars=tab:\ \ ,trail:·,precedes:«,extends:»

set number
set relativenumber

set smartcase

set spelllang=en,fr

call plug#begin(stdpath('data') . '/vimplug')

Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'windwp/nvim-ts-autotag'

Plug 'mhartington/formatter.nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'BurntSushi/ripgrep'

Plug 'lewis6991/gitsigns.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/nvim-compe'
Plug 'ray-x/lsp_signature.nvim'

Plug 'gennaro-tedesco/nvim-jqx'

Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'godlygeek/tabular'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'unblevable/quick-scope'
Plug 'haya14busa/vim-asterisk'

"colorschemes
Plug 'phanviet/vim-monokai-pro'
Plug 'morhetz/gruvbox'
Plug 'haishanh/night-owl.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
Plug 'hzchirs/vim-material'
Plug 'ghifarit53/tokyonight-vim'

call plug#end()

let mapleader=' '
let g:markdown_fenced_languages = ["javascript", "typescript", "sh"]
let g:filetype_pl="prolog"

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

let g:rustfmt_autosave = 2
let g:gitgutter_diff_args = '-w'

let g:user_emmet_leader_key='<C-e>'

nnoremap gd         :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>sh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>gr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>gn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>k  :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>gg :lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap ]g         :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap [g         :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>e  :lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>

" Set completeopt to have a better completion experience
set completeopt=menuone,noselect

nnoremap ' `

nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>ss :set spell!<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>q :q<CR>

"go to  alternate buffer
nnoremap <leader><leader> <C-^>

" keep selection after indentation
vnoremap > >gv
vnoremap < <gv

" use arrows to resize windows
nnoremap <silent> <M-up>    :resize +1<CR>
nnoremap <silent> <M-down>  :resize -1<CR>
nnoremap <silent> <M-left>  :vertical resize -1<CR>
nnoremap <silent> <M-right> :vertical resize +1<CR>

"easy interaction with system clipboard
nnoremap <leader>p "+p
nnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG
vnoremap <leader>y "+y
vnoremap <leader>p "+p

command! Bd :bp | :sp | :bn | :bd "close buffer keeping layout

for key in ['h', 'j', 'k', 'l']
    " for terminal windows also
    exe 'tnoremap <C-'.key.'> <c-\><c-n><C-w>'.key
endfor

nnoremap <silent> <leader>st :vsp term://zsh<CR>

" get out of terminal mode easily
tnoremap <esc><esc> <c-\><c-n>

" toggle folds
nnoremap <tab> za

nnoremap <silent> <esc> :noh<CR>

nnoremap <silent> [<space> :call append(line('.')-1, '')<CR>
nnoremap <silent> ]<space> :call append(line('.'), '')<CR>

"args
nnoremap [a     :previous<CR>
nnoremap ]a     :next<CR>
nnoremap [A     :first<CR>
nnoremap ]A     :last<CR>

"buffes
nnoremap [b     :bp<CR>
nnoremap ]b     :bn<CR>
nnoremap [B     :bf<CR>
nnoremap ]B     :bl<CR>

"location list
nnoremap [l     :lp<CR>
nnoremap ]l     :lne<CR>
nnoremap [L     :lfirst<CR>
nnoremap ]L     :llast<CR>

"quickfix list
nnoremap [q     :cp<CR>
nnoremap ]q     :cn<CR>
nnoremap [Q     :cfirst<CR>
nnoremap ]Q     :clast<CR>

"vim-asterisk stuff
map *  <Plug>(asterisk-z*)
map g* <Plug>(asterisk-gz*)
map #  <Plug>(asterisk-z#)
map g# <Plug>(asterisk-gz#)

set termguicolors
set background=dark

"auy colorscheme variants
let ayucolor='dark' "light, mirage, or dark

let g:gruvbox_contrast_dark = 'hard'

let g:material_style='dark' "dark|light|palenight|oceanic

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
"rmember cursor postion while iterating over matches
let g:asterisk#keeppos = 1

fun! TrimWhitespace ()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    cal winrestview(l:save)
endfun

augroup vimrc
    au!

    "relative numbers for normal mode only
    au InsertEnter * set norelativenumber
    au InsertLeave * set relativenumber

    au FileType *.go setlocal noexpandtab

    " auto reload vimrc on save
    au! BufWritePost init.vim so % | redraw

    "delete trailing white space on save
    au BufWritePre * :call TrimWhitespace()
augroup END

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 50})
augroup END

let g:lightline = {
    \ 'colorscheme': 'monokai_pro',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
        \   'gitbranch': 'FugitiveHead'
        \ },
  \ }

"Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').builtin()<cr>

inoremap <silent><expr> <c-space> compe#complete()
inoremap <silent><expr> <cr> compe#confirm('<cr>')
inoremap <silent><expr> <c-e> compe#close('<c-e>')
inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-h>"

lua <<EOF

-- lsp stuff
require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
local lsp_signature = require "lsp_signature"

for _, server in pairs(servers) do
  require'lspconfig'[server].setup{on_attach = lsp_signature.on_attach()}
end

-- treesitter stuff
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"javascript", "typescript",  "tsx", "html", "css", "c", "go", "rust", "lua"},
  highlight = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
      }
    }
  },
  autotag = {
    enable = true,
  }
}

-- autocomplete
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  },

  source = {
    nvim_lsp = true,
    nvim_lua = true,
    path = true,
    buffer = true,
    -- vsnip = true,
    -- ultisnips = true,
    -- luasnip = true
  }
}

-- formatting
local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
    stdin = true
  }
end

require('formatter').setup({
  logging = false,
  filetype = {
    html = { prettier },
    javascript = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    css = { prettier },
    json = { prettier },
  }
})

-- gitsigns

require('gitsigns').setup()
EOF
