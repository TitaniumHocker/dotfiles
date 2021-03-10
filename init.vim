" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

" Syntax support plugins
Plug 'lervag/vimtex'        " Latex
Plug 'cespare/vim-toml'     " Toml
Plug 'mitsuhiko/vim-jinja'  " Jinja
Plug 'saltstack/salt-vim'   " Salt (sls)
Plug 'stevearc/vim-arduino' " Arduino
Plug 'chr4/nginx.vim'       " NGINX
Plug 'dag/vim-fish'         " Fish shell
Plug 'vim-perl/vim-perl',   " Perl
            \ {'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny'}

" Toolz
Plug 'psf/black', { 'branch': 'stable' } " Black formatter for python files
Plug 'mattn/emmet-vim'                   " Emmet
Plug 'scrooloose/nerdtree',              " NERDTree
            \ { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'       " git integration for nerdtree
Plug 'majutsushi/tagbar'                 " Tags
Plug 'airblade/vim-gitgutter'            " Git
Plug 'wikitopian/hardmode'               " Hardmode, fuck arrows
Plug 'neoclide/coc.nvim',                " Autocompletion from VSCode
            \ {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'              " Autopairs for ({'
" Plug 'coddingtonbear/neomake-platformio' " Platformio integration
Plug 'python-mode/python-mode',          " Additional Python support
            \ { 'for': 'python', 'branch': 'develop' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/fzf',                     " FZF wrapper with cool commands
            \ { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'aurieh/discord.nvim',              " Status for discord
"             \ { 'do': ':UpdateRemotePlugins'}

" Visual
Plug 'vim-airline/vim-airline'           " Airline
Plug 'ryanoasis/vim-devicons'            " Awesome icons
Plug 'flazz/vim-colorschemes'            " 1000 colorschemes
Plug 'morhetz/gruvbox'                   " Gruvbox colorcheme
Plug 'junegunn/seoul256.vim'             " Seoul 256 colorcheme
Plug 'nightsense/rusticated'             " Rusticated colorcheme

" Initialize plugin system
call plug#end()

" Basic configuration
set number relativenumber
autocmd TermOpen * setlocal nonumber norelativenumber
set expandtab
set shiftwidth=4
set tabstop=4
syntax on

if has('mouse')
    set mouse=a
endif

set clipboard+=unnamed
set showtabline=2

" Hardmode config
let g:HardMode_level = 'wannabe'
let g:HardMode_hardmodeMsg = 'Fuck arrows, punk!'
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

" Pymode config
let g:python3_host_prog = '/usr/sbin/python'
let g:pymode_options_max_line_length = 100
let g:pymode_lint = 0 " Disable linters in Pymode, COC used

" Some snippets configuration
let g:UltiSnipsExpandTrigger="<C-s>"
let g:UltiSnipsJumpForwardTrigger="<C-]>"
let g:UltiSnipsJumpBackwardTrigger="<C-[>"

augroup tt_ft
  au!
  autocmd BufNewFile,BufRead *.tt   setf tt2html
augroup END

" Tab = 2 space for some filetypes
autocmd FileType
    \ html,jinja.html,css,c,cpp,js,yml,yaml,toml,sls,tt,tt2,tt2html,html.j2,javascript
    \ setlocal shiftwidth=2 softtabstop=2

" Enable spell check for text files
set spelllang=en_us,ru_ru
autocmd FileType text,md,rst set spell

" Theme configuration
set termguicolors
colorscheme gruvbox
" colorscheme rusticated
" let g:airline_theme='rusticated'
let g:airline_powerline_fonts = 1

" Some search tuning
set hlsearch
set incsearch

" Mappings
map <C-n> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
map <C-m> :CocCommand python.sortImports<CR>
map <C-b> :Black <CR>

" COC config from github official page

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
