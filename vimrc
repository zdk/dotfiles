" Let vim break compatibility with vi :)
set nocompatible

" ============================================================================
"     Plug INIT
" ============================================================================

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Navigation
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-vinegar'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code linting
Plug 'scrooloose/syntastic'

" Bracket paring
Plug 'tpope/vim-unimpaired'

" Whitespace highlighting
Plug 'ntpeters/vim-better-whitespace'

" Commentor
Plug 'tomtom/tcomment_vim'

" Syntax
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'mxw/vim-jsx'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'tomlion/vim-solidity'
Plug 'hashivim/vim-terraform'
Plug 'moby/moby' , {'rtp': '/contrib/syntax/vim/'}

" Indent
Plug 'nathanaelkane/vim-indent-guides'
Plug 'junegunn/vim-easy-align'

" Mapping
Plug 'tpope/vim-unimpaired'

" HTML
Plug 'mattn/emmet-vim'

" Markdown
Plug 'iamcco/markdown-preview.vim'

" Motion
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'

" Fuzzy search
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'

" Completion
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Test (Plugin Development)
Plug 'junegunn/vader.vim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()

" Just for fun
echom 'Yo!, Opening file size: ' getfsize(expand(@%)) ' bytes'
map - ddp
map _ ddkkp

"=============================================================================

" ============================================================================
"     Base SETTINGS
" ============================================================================
let mapleader=","
filetype off
filetype plugin indent on
set ttyfast
set laststatus=2
set encoding=utf-8             " Set default encoding to UTF-8
set autoread                   " Automatically reread changed files without asking me anything
set autoindent
set backspace=indent,eol,start " Makes backspace key more powerful.
set incsearch                  " Shows the match while typing
set hlsearch                   " Highlight found searches
set mouse=a                    " Enable mouse mode
set noerrorbells               " No beeps
set number                     " Show line numbers
set showcmd                    " Show me what I'm typing
set noswapfile                 " Don't use swapfile
set nobackup                   " Don't create annoying backup files
set splitright                 " Split vertical windows right to the current windows
set splitbelow                 " Split horizontal windows below to the current windows
set autowrite                  " Automatically save before :next, :make etc.
set hidden
set fileformats=unix,dos,mac   " Prefer Unix over Windows over OS 9 formats
set noshowmatch                " Do not show matching brackets by flickering
set noshowmode                 " We show the mode with airline or lightline
set ignorecase                 " Search case insensitive...
set smartcase                  " ... but not it begins with upper case
set completeopt=menu,menuone
set nocursorcolumn             " speed up syntax highlighting
set nocursorline
set updatetime=300
set pumheight=10               " Completion window max size
set conceallevel=2             " Concealed text is completely hidden
set lazyredraw
set timeoutlen=1000 ttimeoutlen=50

if has('mac')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

augroup filetypedetect
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType help wincmd L
  autocmd BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
  autocmd BufNewFile,BufRead *.hcl setf conf
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.md setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.html setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sh setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.css setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.scss setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
augroup END

" ============================================================================

" ============================================================================
"     Plugins' CONFIG
" ============================================================================

" vim-snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" vim-airline
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

" vim-easy-align
vmap <Enter> :EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim-go
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_options = {
  \ 'goimports': '-local do/',
  \ }

let g:go_debug_windows = {
      \ 'vars':  'leftabove 35vnew',
      \ 'stack': 'botright 10new',
\ }

let g:go_sameid_search_enabled = 1
let g:go_test_prepend_name = 1

" put quickfix window always to the bottom
augroup quickfix
    autocmd!
    autocmd FileType qf wincmd J
    autocmd FileType qf setlocal wrap
augroup END

let g:go_list_type = "quickfix"

let g:go_auto_type_info = 0
let g:go_auto_sameids = 0

let g:go_def_mode = "guru"
let g:go_echo_command_info = 1
let g:go_gocode_autobuild = 1
let g:go_gocode_unimported_packages = 1

let g:go_autodetect_gopath = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 0
let g:go_highlight_format_strings = 0

let g:go_modifytags_transform = 'camelcase'
let g:go_fold_enable = []

nmap <C-g> :GoDecls<cr>
imap <C-g> <esc>:<C-u>GoDecls<cr>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup go
  autocmd!

  autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)

  autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)

  autocmd FileType go nmap <silent> <Leader>i <Plug>(go-info)
  autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)

  autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

  autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)

  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_enable_signs  = 1
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_solidity_solc_checker = 1

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

" ctrlp-funky
let g:ctrlp_funky_matchtype = 'path'

" vim-jsx
let g:jsx_pragma_required = 1

" vim-jsbeautify
autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>

let g:deoplete#enable_at_startup = 1

" vim-projectionist
let g:projectionist_heuristics = {
      \   '*': {
      \     '*.c': {
      \       'alternate': '{}.h',
      \       'type': 'source'
      \     },
      \     '*.h': {
      \       'alternate': '{}.c',
      \       'type': 'header'
      \     },
      \
      \     '*.js': {
      \       'alternate': [
      \         '{dirname}/{basename}.test.js',
      \         '{dirname}/tests/{basename}-test.js'
      \       ],
      \       'type': 'source'
      \     },
      \     '*.sol': {
      \       'alternate': [
      \         '{dirname}/{basename}.test.js',
      \         '{dirname}/tests/{basename}.test.js'
      \       ],
      \       'type': 'source'
      \     },
      \     '*.test.js': {
      \       'alternate': [
      \           '{basename}.js',
      \           '{basename}.sol',
      \       ],
      \       'type': 'test',
      \     },
      \     '**/tests/*-test.js': {
      \       'alternate': '{dirname}/{basename}.js',
      \       'type': 'test'
      \     }
      \   }
      \ }

" vim-vinegar
"
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" vim-terraform
"
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1

" vim-easy-align
"

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ============================================================================

" ============================================================================
"     Custom MAPPING
" ============================================================================

" Super magic, Always!
vnoremap / /\v
nnoremap / /\v

" Highlighting on/off
noremap <F4> :set hlsearch! hlsearch?<CR>

" Remove search highlight
nnoremap <Leader><space> :nohlsearch<CR>
" Print full path
noremap <C-f> :echo expand("%:p")<cr>
" Quick save
noremap <Leader>w <ESC>:w<CR>
inoremap <Leader>w <ESC>:update<CR>i

" Some useful quickfix shortcuts for quickfix
noremap <C-n> :cn<CR>
noremap <C-m> :cp<CR>
nnoremap <Leader>a :cclose<CR>

" ctrlp-funky
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
" open current file with Chrome
nnoremap <F12>c :exe ':silent !open -a /Applications/Google\ Chrome.app %'<CR>

" pair
"inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>

silent! nnoremap <F6> :SyntasticToggleMode<CR>

" toggle case
noremap <F8> <Esc>g~iwea

" Quick edit vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>
