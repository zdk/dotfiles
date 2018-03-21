set nocompatible              " be iMproved, required
filetype off                  " required

" mkdir -p ~/.vim/bundle/ && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

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

" ################
" Plugin Configure
" ################

" ####################
" End Plugin configure
" ####################

" see :h vundle for more details or wiki for FAQ

" Custom configure

" Buffer
map <left> :bprevious<CR>
map <right> :bnext<CR>
map <Esc><Esc> :w<CR>

let g:netrw_liststyle = 3
