set nocompatible              " be iMproved, required
filetype off                  " required

" mkdir -p ~/.vim/bundle/ && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tpope/vim-fugitive.git'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Shougo/neocomplete.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'junegunn/vim-easy-align'
Plugin 'szw/vim-tags'
" ruby
Plugin 'vim-ruby/vim-ruby'
" js
Plugin 'einars/js-beautify'
Plugin 'moll/vim-node'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on
set backspace=2
set encoding=utf-8                       " UTF-8
set expandtab                            " Insert space characters whenever the tab key is pressed
set tabstop=2 shiftwidth=2 softtabstop=2 " Insert 2 spaces for a tab, 2 spaces for indent, cause <Tab> and <BS> to insert and delete 2 spaces
set clipboard=unnamed
let mapleader = ","
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting

"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" Plugin Configure
"
" vim tags
let g:vim_tags_auto_generate = 1

" ctrlp-funky
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_matchtype = 'path'

" airline
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

" neocomplete
let g:neocomplete#enable_at_startup = 1

" vim-easy-align
vmap <Enter> :EasyAlign
nmap ga :EasyAlign

" syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs  = 1
nnoremap <leader>. :CtrlPTag<cr>

" vim-jsbeautify
map <c-f> :call JsBeautify()<cr>
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

" vim-jsbeautify visualmode
autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>

" see :h vundle for more details or wiki for FAQ
" non-Plugin stuff after this line

" Custom
" buffer
map <left> :bprevious<CR>
map <right> :bnext<CR>
map <Esc><Esc> :w<CR>
let g:netrw_liststyle = 3
