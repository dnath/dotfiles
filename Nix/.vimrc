set nu
highlight LineNr ctermbg=black

set noignorecase
set hlsearch
set incsearch

set showmatch
set mat=2

"set foldmethod=indent
"set foldnestmax=2
"set foldlevelstart=1
"set foldenable

set autoindent
set smartindent

set tabstop=2
set shiftwidth=2
set expandtab	

set ruler
" Format the status line
set statusline=%f\ %m%r%h\ %w\ %y\ %=Line:\ %l\ Column:\ %c

" set textwidth=79
" set colorcolumn=80

""" pathogen.vim
execute pathogen#infect()
call pathogen#helptags()    " generate helptags for everything in 'runtimepath'
" syntax on
filetype plugin indent on

if has('syntax') && (&t_Co > 2)
  syntax on
endif

""" NERDTree
" Ctrl+N Shortcut
map <C-n> :NERDTreeToggle<CR>
" open NERDTree
au VimEnter * if &filetype !=# 'gitcommit' | NERDTree | wincmd p | endif
au BufEnter * lcd %:p:h " set pwd
" close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

