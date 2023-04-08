" UI
set nocompatible
syntax enable
colorscheme nord
source ~/.config/nvim/statusline.vim
set termguicolors
set number relativenumber
set noshowcmd
set wrap
set linebreak
set list 

" UX
set scrolloff=2
set splitbelow splitright
set nostartofline
set backspace=indent,eol,start
set autoread

" General
set clipboard=unnamedplus
set encoding=utf-8
filetype on

" Tabs
set tabstop=2
" set softtabstop=0
" set noexpandtab
" set shiftwidth=2
set autoindent
set smartindent
" set cindent
set listchars=tab:│\ 

" Search
set ignorecase
set nohlsearch

" Cursor
set guicursor=i:ver90
set mouse=a
set cursorline
set colorcolumn=99999 " bug fix for indent-blankline
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " disable auto comment in next line

" Bell
set noerrorbells
set vb t_vb=

" Nord theme
let g:nord_cursor_line_number_background=1

" recommended styles
let g:rust_recommended_style=0

au BufNewFile,BufRead *.cron :set filetype=crontab
" au BufWritePost *.tex !make


"=== Keybindings
let mapleader=","

" copy line without line break
nnoremap Y y$
" nnoremap Y mQ^y$`Q

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

" commenting
nnoremap <leader><Space> <Plug>CommentaryLine
vnoremap <leader><Space> <Plug>Commentary

" auto-close brackets
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" continue highlighting after indentation
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>

cnoremap <silent> <expr> <enter> CenterSearch()


"=== Functions
function! CenterSearch()
	let cmdtype = getcmdtype()
	if cmdtype == '/' || cmdtype == '?'
		return "\<enter>zz"
	endif
	return "\<enter>"
endfunction


"=== Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-commentary'
au FileType c setlocal commentstring=\/\/\ %s

Plug 'tpope/vim-sleuth'

Plug 'lukas-reineke/indent-blankline.nvim'
let g:indent_blankline_show_trailing_blankline_indent = v:false

Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
let g:Hexokinase_highlighters = ['backgroundfull']
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

call plug#end()


" === Lua
lua require('completion')


" === IDE-like behaviour

" Rust
au BufWritePost *.rs :silent !rustfmt %
