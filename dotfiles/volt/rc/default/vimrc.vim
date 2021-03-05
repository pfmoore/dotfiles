" vim: set et tw=0:
" My Vim configuration

" We're vim, not vi!
set nocompatible

" Use UTF8 as the default encoding, as this handles
" the full Unicode character set. Note that latin1
" files will still have their encoding preserved.
set encoding=utf-8

" Use DirectX, because it gives better font rendering
set renderoptions=type:directx

" Use <SPACE> as the leader. Needs to be at the top, before any mappings.
let mapleader=" "

" Required:
filetype plugin indent on

" General settings
set nowrap        " Horizontal scrolling rather than displaying lines wrapped
set showmatch     " Flash on matching brackets
set dir=$TEMP     " always save swap files to the temp dir
"set exrc          " read a local .vimrc file

" Indenting text
" Syntax-based indentation (indentexpr) is usually used.
" This is for plain text.
set autoindent      " Auto-indent new lines

" Search behaviour
set ignorecase          " don't worry about case when matching...
set smartcase           " unless the search string contains capitals

" Completion menu
set wildmenu            " Show a menu when completing on the command line

" Don't require a save when switching buffers
set hidden              " Hide buffers rather than unloading them

" Line numbers (relative)
set number
set relativenumber

" Show the current line
set cursorline

" Indentation and tabs
set shiftwidth=4        " indents each 4 characters
set smarttab            " tabs at start of line indent
set expandtab           " tabs are expanded to spaces

" Cursor movement
set nostartofline              " Don't jump to start of line
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set whichwrap=b,s,<,>,[,]      " allow arrow keys etc to wrap over line ends

" Backup files
set nobackup            " do not keep a backup file
set nowritebackup       " do not write a backup file at all
set backupdir=.,$TEMP   " backup files go to current dir or windows temp

" Persistent undo
set undodir=~/.vim/undodir
set undofile

" We don't want Ctrl-A and Ctrl-X to assume octal if there's a leading zero
set nrformats-=octal

set complete=.,w,b,u,i  " Insert-completion
set suffixes+=.orig     " Complete on these files last

set clipboard=unnamed   " Make yanks go to the clipboard by default
set winaltkeys=no       " Don't use alt for menu items, free them for maps

set printfont=Courier_New:h8
set printoptions=syntax:n " Don't use syntax highlighting

" Keep viminfo, but put it in the temp dir (it's not that critical)
set viminfo+=n$TEMP/_viminfo

" Use ripgrep
set grepprg=rg\ --vimgrep

" Use powershell
set shell=powershell
set shellcmdflag=-command

" Enable syntax highlighting and filetype detection
syntax on
syntax sync fromstart
filetype plugin indent on

" There is no need for a separate gvimrc file...
if has('gui_running')
    set guifont=Cascadia_Code_PL:h14,Source_Code_Pro:h14,DejaVu_Sans_Mono:h14,Consolas:h14,Courier_New:h14
    set background=dark
    " Set colour scheme, fall back to built in 'desert' scheme
    try
        colorscheme gruvbox
    catch /E185/
        colorscheme desert
    endtry
    set guioptions-=T
    set guioptions-=L
    set guioptions-=m
    set listchars=tab:»·,eol:¶
    set mousehide
    set keymodel=startsel
end

" Personal snippet directory
let g:UltiSnipsSnippetsDir = "~/vimfiles/ultisnips"
" Use TAB to expand and jump in snippets
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsListSnippets = "<C-Tab>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"


" ack.vim: Use ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Use an embedded Python distribution if present
let pyembed=$VIM . '/python'
if isdirectory(pyembed)
    let dlls = glob(pyembed . '/python3?.dll', 1, 1)
    if !empty(dlls)
      let &pythonthreedll = dlls[0]
    endif
endif

" Run the current buffer through Python
command -range=% PP <line1>,<line2>Clam python

" Personal mappings
map <Leader>df :NERDTree %:p:h<CR>
map <Leader>dc :NERDTree<CR>
map <Leader>fc :e $MYVIMRC<CR>

" Move through buffers (from "But She's a Girl)
nmap <Leader><Left> :bp<CR>
nmap <Leader><Right> :bn<CR>

" Diffsplit this buffer vs the on-disk copy.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
"
" Could also do this by loading the on-disk version into a new scratch
" buffer (how? :0r is the best, I think...) and then doing :diffthis
" on both buffers...
" function! DiffThis()
"     " Autowrite no longer affects us, as we're using system() not :!
"     "let local_aw = &aw
"     "set noaw
"     let temp = tempname()
"     " OS-dependent, sadly...
"     call system("copy " . expand("%") . " " . temp)
"     exe "silent vert diffsplit " . temp
"     " Set the temporary file buffer to be a scratch buffer
"     silent file Original-Contents
"     set buftype=nofile
"     " Delete the temporary file
"     call delete(temp)
"     "let &aw = local_aw
" endfunction
" command! DT call DiffThis()
