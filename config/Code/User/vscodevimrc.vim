" General
set clipboard=unnamedplus
set encoding=utf-8
filetype on


"=== Keybindings
let mapleader=","

" copy line without line break
nnoremap Y y$

" align search results in middle
nnoremap n nzz
nnoremap N Nzz

" redo
nnoremap U <C-r>

" page up/down
nnoremap J <C-d>zz
nnoremap K <C-u>zz
vnoremap J <C-d>zz
vnoremap K <C-u>zz

" continue highlighting after indentation
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>

" split sentences into lines using split-sentences.py
" nnoremap <leader>ss :!split-sentences.py<CR>
nnoremap <silent> ss :'<,'>!split-sentences.py<CR>
vnoremap <silent> ss :'<,'>!split-sentences.py<CR>
