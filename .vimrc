set nocompatible
syntax on
filetype off
setlocal spell spelllang=en_us
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
set t_Co=256
set background=dark
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set autoindent
let mapleader = ','
nnoremap ; :
set encoding=utf-8
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle "jnurmine/Zenburn"
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'flazz/vim-colorschemes'
Bundle 'corntrace/bufexplorer'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Bundle 'altercation/solarized', {'rtp': 'vim-colors-solarized/'}
Bundle 'Lokaltog/vim-powerline'
Bundle 'benmills/vimux'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
" Pick one of the checksyntax, jslint, or syntastic
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'godlygeek/tabular'
if executable('ctags')
  Bundle 'majutsushi/tagbar'
  Bundle 'xolox/vim-misc'
  Bundle 'xolox/vim-easytags'
  Bundle 'vim-scripts/taglist.vim'
endif
Bundle 'Shougo/neocomplcache'
Bundle 'honza/dockerfile.vim'
Bundle 'rodjek/vim-puppet'
Bundle 'digitaltoad/vim-jade'
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
set backspace=indent,eol,start  " backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " show matching brackets/parenthesis
set incsearch                   " find as you type search
set hlsearch                    " highlight search terms
set winminheight=0              " windows can be 0 line high
set ignorecase                  " case insensitive search
set smartcase                   " case sensitive when uc present
set wildmenu                    " show list instead of just completing
set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
set scrolljump=5                " lines to scroll when cursor leaves screen
set scrolloff=3                 " minimum lines to keep above and below cursor
set foldenable                  " auto fold code
set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
colorscheme zenburn
set background=dark
"colorscheme solarized
let g:Tex_ViewRule_pdf='Preview'
let g:Tex_CompileRule_pdf = 'xelatex --interaction=nonstopmode --shell-escape $*'
set laststatus=2
let g:Powerline_symbols = 'fancy'
set timeoutlen=1000 ttimeoutlen=0
nnoremap <silent> <leader>tt :TlistToggle<CR>
let g:Tlist_Use_Right_Window   = 1
let Tlist_WinWidth = 50
let g:neocomplcache_enable_at_startup = 1
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
set tags=~/.vimtags
map <leader>fi :setlocal foldmethod=indent<cr>
map <leader>fs :setlocal foldmethod=syntax<cr>
let g:syntastic_always_populate_loc_list=1
filetype plugin indent on
let g:is_bash = 1
let g:sh_fold_enabled = 3
