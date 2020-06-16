"vundle
set t_Co=256
set nocompatible
filetype off
set ts=4
set sts=4
set expandtab
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

let mapleader = " "
nnoremap <C-s> <ESC>:w<CR>i
nnoremap <C-j> <C-e> <C-e> <C-e>
nnoremap <C-k> <C-y><C-y><C-y>
nnoremap <C-h> hhhhh
nnoremap <C-l> lllll
nnoremap <leader> w :w<CR>
function! RunInBackground(cmd)
" Setup python
if (has('python3'))
    let s:py_exe = 'python3'
elseif (has('python'))
    let s:py_exe = 'python'
else
    echohl ErrorMsg
    echo 'vim-llp: python required'
    echohl None
    finish
endif
execute s:py_exe "<< EEOOFF"

try:
    subprocess.Popen(
            vim.eval('a:cmd'),
            shell = True,
            universal_newlines = True,
            stdout=open(os.devnull, 'w'), stderr=subprocess.STDOUT)

except:
    pass
EEOOFF
endfunction

function CompileLaTex(type)
    let l:echo_info = system(a:type, expand('%'))
    if v:shell_error != 0
        echo 'Failed to compile xelatex'
	    execute('!'.a:type.' '.expand('%'))
        return
    else
        echo 'Done.'
    " else
	" let l:echo_info2 = system('bibtex ' . expand('%')[0:-5])
	" if v:shell_error != 0
	"     echo 'Failed to compile bibtex'
	"     execute('!bibtex '.expand('%')[0:-5])
	" else
	"     echo 'Done.'
	" endif
    endif
endfunction

map <leader>c :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
	endif
endfunction

map <leader>g :call Rungdb()<CR>
func! Rungdb()
       exec "w"
       exec "!g++ % -g -o %<"
       exec "!gdb ./%<"
endfunc

" nnoremap <leader>x :!xelatex %<CR>
nnoremap <leader>lx :call CompileLaTex('xelatex')<CR>
nnoremap <leader>lp :call CompileLaTex('pdflatex')<CR>
nnoremap <leader>lb :execute('!bibtex ' . expand('%')[0:-5])<CR>
" nnoremap <leader>lt :let g:livepreview_engine='xelatex'<CR>
" nnoremap <leader>lv :LLPStartPreview<CR>
nnoremap <leader>lv :call RunInBackground('open -a Preview ' . expand('%')[0:-5] . '.pdf')<CR>
inoremap jk <ESC>
set tabstop=4
set softtabstop=4
set shiftwidth=4

"set autoindent
set smartindent
" Plugin 'vim-latex/vim-latex'
" let g:Tex_Folding = 0
" " let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 --interaction=nonstopmode $*'
" filetype plugin on
" let b:suppress_latex_suite = 1

let g:livepreview_previewer = 'open -a Preview'
Plugin 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim' 
" autocmd VimEnter * NERDTree
let NERDTreeShowLineNumbers=1
map <leader>t <plug>NERDTreeTabsToggle<CR>

"  isnowfy only compatible with python not python3
Plugin 'isnowfy/python-vim-instant-markdown'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'suan/vim-instant-markdown'
Plugin 'nelstrom/vim-markdown-preview'
"python sytax checker
Plugin 'nvie/vim-flake8'
" Plugin 'vim-scripts/Pydiction'
Plugin 'vim-scripts/indentpython.vim'
" Plugin 'scrooloose/syntastic'

Plugin 'Valloric/YouCompleteMe'
" let g:ycm_python_interpreter_path = '~/anaconda2/bin/python2.7'
let g:ycm_python_interpreter_path = '~/opt/anaconda3/bin/python3.7'
" let g:ycm_python_sys_path = []
" let g:ycm_extra_conf_vim_data = [
" 	\ 'g:ycm_python_interpreter_path',
"  	\ 'g:ycm_python_sys_path'
"  	\]
" let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion=1

"custom keys
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

 

"Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
""code folding
Plugin 'tmhedberg/SimpylFold'

"Colors!!!
Plugin 'jnurmine/Zenburn'
let g:zenburn_transparent = 1
let g:zenburn_high_Contrast = 1
let g:zenburn_alternate_Visual = 1
let g:zenburn_old_Visual = 1
syntax enable
set background=dark
colorscheme zenburn
Plugin 'Mark'

set nocompatible
filetype off

call vundle#end()

filetype plugin indent on    " enables filetype detection
let g:SimpylFold_docstring_preview = 1
set cindent
"autocomplete
" call togglebg#map("<F2>")

"set guifont=Monaco:h14

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"I don't like swap files
set noswapfile

"turn on numbering
set nu

autocmd FileType python set omnifunc=pythoncomplete#Complete

"------------Start Python PEP 8 stuff----------------
" Number of spaces that a pre-existing tab is equal to.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4

"spaces for indents
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py set softtabstop=4

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
au BufRead,BufNewFile *.py,*.pyw, set textwidth=100

" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

" Set the default file encoding to UTF-8:
set encoding=utf-8

" For full syntax highlighting:
let python_highlight_all=1
syntax on

" Keep indentation level from previous line:
autocmd FileType python set autoindent

" make backspaces more powerfull
set backspace=indent,eol,start


"Folding based on indentation:
autocmd FileType python set foldmethod=manual
"use space to open folds
"nnoremap <space> za 
"----------Stop python PEP 8 stuff--------------

"js stuff"
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
