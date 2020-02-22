" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" NerdTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'nightsense/carbonized'

" Autocomplete plugin
Plug 'ycm-core/YouCompleteMe'
" Plug 'davidhalter/jedi-vim'

" Jinja support plugin
Plug 'lepture/vim-jinja'

" Pairs for ({' plugin
Plug 'jiangmiao/auto-pairs'

" Arduino syntax plugin
Plug 'stevearc/vim-arduino'

" Additional python support
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" Initialize plugin system
call plug#end()

" My options

set number
set expandtab
set shiftwidth=4
set tabstop=4
syntax on
set mouse=a

" Tab = 4 space for html, css, jinja files
autocmd FileType html setlocal shiftwidth=2 softtabstop=2
autocmd FileType jinja.html setlocal shiftwidth=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 softtabstop=2


colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'soft'


set hlsearch
set incsearch

" Mappings

map <C-n> :NERDTreeToggle<CR>

