vim.cmd [[
" Autoconfigure buffer with terminal
autocmd TermOpen * setlocal nonumber norelativenumber

" Set filetype for template toolkit files
augroup tt_ft
    au!
    autocmd BufNewFile,BufRead *.tt setf tt2html
augroup END

" Set filetype for jinja2 html templates
augroup j2_ft
    au!
    autocmd BufNewFile,BufRead *.jinja2.html,*.j2.html,*.jinja.html set ft=jinja.html
augroup END

" Set filetype for C header files
augroup ch_ft
    au!
    autocmd BufNewFile,BufRead *.h set ft=c
augroup END

" Enable spell check in text files
autocmd FileType text,md,rst set spell

" Remove trailling spaces on file save
fun! TrimTraillingSpaces()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
augroup traillingspaces_trimmer
    autocmd!
    autocmd BufWritePre * :call TrimTraillingSpaces()
augroup END
]]
