""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
" 
" Dev Nath
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

"" vim, not vi; be iMproved ;)
set nocompatible

"" Make backspace work like in other programs.
set backspace=indent,eol,start

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
" Vundle settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/.vim/bundle/others')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" Solarized color scheme from https://github.com/altercation/vim-colors-solarized
Plugin 'altercation/vim-colors-solarized'

" UltiSnips from https://github.com/SirVer/ultisnips
" TODO(dnath): Need to make it work with vim+py3 in macOS.
" Plugin 'SirVer/ultisnips'

" Git plugin from https://github.com/tpope/vim-fugitive
Plugin 'tpope/vim-fugitive'

" Nerdtree from https://github.com/preservim/nerdtree
Plugin 'preservim/nerdtree'
" Nerdcommenter from https://github.com/preservim/nerdcommenter
Plugin 'preservim/nerdcommenter'

" delimitMate from https://github.com/Raimondi/delimitMate
Plugin 'Raimondi/delimitMate'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation, Tabs
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" indentation
set autoindent
set smartindent

"" tabs
set tabstop=2
set shiftwidth=2
set expandtab	

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation, Tabs, TextWidth Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Notify if text width > 80c
"" Ref: https://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%81v.\+/

"" 
" set textwidth=79
" set colorcolumn=80

