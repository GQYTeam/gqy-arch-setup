# GQYOS Neovim Configuration
# 为顾清影而造

" ========== 基础 ========== "
set number
set relativenumber
set cursorline
set termguicolors
set signcolumn=yes
set scrolloff=8
set sidescrolloff=8
set mouse=a
set clipboard=unnamedplus
set ignorecase
set smartcase
set updatetime=250
set undofile
set splitright
set splitbelow
set nowrap
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" ========== 按键映射 ========== "
let mapleader = " "

" 快速保存/退出
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>

" 窗口导航
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 缓冲区切换
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" 清除搜索高亮
nnoremap <Esc> :noh<CR>

" 更好的缩进
vnoremap < <gv
vnoremap > >gv

" 移动行
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" ========== 插件管理 (vim-plug) ========== "
call plug#begin('~/.local/share/nvim/plugged')

" 外观
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" 导航
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-tree/nvim-web-devicons'

" 编辑
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'windwp/nvim-autopairs'

" Git
Plug 'lewis6991/gitsigns.nvim'

" 状态栏
Plug 'nvim-lualine/lualine.nvim'

call plug#end()

" ========== 插件配置 ========== "

" Catppuccin 主题
colorscheme catppuccin

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <leader>fd <cmd>Telescope diagnostics<CR>

" Lualine
lua << EOF
require('lualine').setup {
  options = { theme = 'catppuccin' }
}
EOF

" Gitsigns
lua << EOF
require('gitsigns').setup()
EOF

" Autopairs
lua << EOF
require('nvim-autopairs').setup()
EOF

" ========== 文件类型 ========== "
autocmd FileType markdown setlocal wrap
autocmd FileType python setlocal tabstop=4 shiftwidth=4
autocmd FileType javascript,typescript,json,yaml setlocal tabstop=2 shiftwidth=2
