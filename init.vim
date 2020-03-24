" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" NerdTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'
Plug 'tomasr/molokai'
Plug 'fmoralesc/molokayo'
Plug 'junegunn/seoul256.vim'

" Autocomplete plugin
Plug 'ycm-core/YouCompleteMe'
Plug 'davidhalter/jedi-vim'

" Jinja support plugin
Plug 'lepture/vim-jinja'

" Pairs for ({' plugin
Plug 'jiangmiao/auto-pairs'

" Arduino syntax plugin
Plug 'stevearc/vim-arduino'

" Additional python support
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" NGINX Syntax
Plug 'chr4/nginx.vim'

" Initialize plugin system
call plug#end()

" My options

set number
set expandtab
set shiftwidth=4
set tabstop=4
syntax on
set mouse=a

" Pymode config
let g:python3_host_prog = '/usr/sbin/python3'
let g:pymode_lint_options_pyflakes = {'ignore':'W0404'}
let g:pymode_lint_options_pep8 = {'ignore':'E501'}

" Tab = 4 space for html, css, jinja files
autocmd FileType html setlocal shiftwidth=2 softtabstop=2
autocmd FileType jinja.html setlocal shiftwidth=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 softtabstop=2

" GruvBox color scheme settings
"colorscheme gruvbox
"set background=dark
"let g:gruvbox_contrast_dark = 'soft'

" Ayu color scheme settings
"set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
"colorscheme ayu

" Molokayo
"colorcheme molokayo

colo seoul256-light
set background=light
"let g:seoul256_background = 252

set hlsearch
set incsearch


" Mappings

map <C-n> :NERDTreeToggle<CR>

