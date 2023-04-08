set noshowmode
set laststatus=2

set statusline=

set statusline+=%1*
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=\ 

set statusline+=%#WildMenu#
" set statusline+=\ %{StatuslineGit()}

set statusline+=%#StatusLineNC#
set statusline+=%2*
set statusline+=\ %t " file name
set statusline+=%m " modified flag
set statusline+=\ 

set statusline+=%= " go to right side

set statusline+=%8*
set statusline+=\ %y " file type
set statusline+=\ 

set statusline+=%9*
set statusline+=\ :%c " column number
set statusline+=\ %l/%L " current line/total lines
set statusline+=\ %p%% " percentage through file
set statusline+=\ 

" Color theme
" default normal mode
hi User1 guifg=#353B4A guibg=#8FAAC9
" filename
hi User2 guifg=#d8dee9 guibg=#3b4252
" file type
hi User8 guifg=#353B4A guibg=#787C8F
" lines
hi User9 guifg=#353B4A guibg=#8D91A7

au InsertEnter * hi User1 guibg=#AEC694
au InsertLeave * hi User1 guibg=#8FAAC9
" au CmdlineEnter * hi User1 guibg=#EBD191
" au CmdlineLeave * hi User1 guibg=#8FAAC9

" Functions
let g:currentmode={
       \ 'n'  : 'N',
       \ 's'  : 'N',
       \ 'v'  : 'V',
       \ 'V'  : 'V',
       \ "\<C-V>"  : 'V',
       \ "^V"  : 'V',
       \ 'i'  : 'I',
       \ 'R'  : 'V',
       \ 'Rv' : 'V',
       \ 'c'  : 'C',
       \}

function! GitBranch()
  return system(" git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'" )
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction
