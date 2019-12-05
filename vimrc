" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" NerdTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Color schemes
Plug 'morhetz/gruvbox'

" Autocomplete plugin
Plug 'ycm-core/YouCompleteMe'

" Jinja support plugin
Plug 'lepture/vim-jinja'

" Pairs for ({' plugin
Plug 'jiangmiao/auto-pairs'

" Initialize plugin system
call plug#end()

" My options

set number
set expandtab
set tabstop=4
syntax on

colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'soft'

set hlsearch
set incsearch

" Mappings

map <C-n> :NERDTreeToggle<CR>

