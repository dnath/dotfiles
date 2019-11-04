""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
" 
" Dibyendu Nath
" dev.nath.cs@gmail.com 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Repeat()
  let times = input("Count: ")
  let char  = input("Char: ")
  exe ":normal a" . repeat(char, times)
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" vim, not vi
set nocompatible

"" Play nice with tmux (already in iterm2)
set term=xterm-256color

"" line numbers
set nu    

"" search
set noignorecase
set hlsearch
set incsearch

"" matching braces
set showmatch
set mat=2

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"" foldmethod
" set foldmethod=indent
" set foldnestmax=2
" set foldlevelstart=1
" set foldenable

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation, Tabs, TextWidth Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" indentation
set autoindent
set smartindent

"" tabs
set tabstop=2
set shiftwidth=2
set expandtab	

"" 
" set textwidth=79
" set colorcolumn=80


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status Line
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
set ruler
set statusline=%f\ %m%r%h\ %w\ %y\ %=Line:\ %l\ Column:\ %c

"" Always display the statusline in all windows
set laststatus=2
"" Hide the default mode text (e.g. -- INSERT -- below the statusline)
" set noshowmode


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pathogen Init
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
execute pathogen#infect()
call pathogen#helptags()    " generate helptags for everything in 'runtimepath'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" powerline Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
" let g:Powerline_symbols='fancy'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" go
set rtp+=$GOROOT/misc/vim

"" syntax on
filetype plugin indent on
if has('syntax')
  syntax on
endif

set background=dark
highlight LineNr ctermbg=black

colorscheme solarized

"" solarized options 
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mouse Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
set mousehide


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Ctrl+N Shortcut
map <C-n> :NERDTreeToggle<CR>

"" open NERDTree
au VimEnter * if &filetype !=# 'gitcommit' | NERDTree | wincmd p | endif
au BufEnter * lcd %:p:h " set pwd

"" close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") 
				\ && b:NERDTreeType == "primary") | q | endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" imap Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
imap <C-r> <C-o>:call Repeat()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Remember last cursor position
au BufReadPost * if line("'\"") > 1 
	 \ && line("'\"") <= line("$") | exe "normal! g'\"" | endif



