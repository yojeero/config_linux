""" $XDG_CONFIG_HOME/nvim/init.vim

"""" Plugin manager
"" Auto-install vim-plug plugin manager when it is not already installed.
"if empty(glob('~/.config/nvim/autoload/plug.vim'))
"    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"    autocmd VimEnter * PlugInstall --sync | source $VIMINIT
"endif
"
"""" Plugins
"call plug#begin('~/.config/nvim/plugged')
"Plug 'tpope/vim-surround'
"Plug 'vim-airline/vim-airline'
"Plug 'ap/vim-css-color'
"call plug#end()
"
"""" Buildin plugins
"filetype plugin on

""" test
augroup dev
    autocmd!
    autocmd BufNewFile,BufRead *vifm* set syntax=vim
    autocmd BufRead,BufNewFile *.v
            \ set filetype=coq |
            \ setlocal softtabstop=2 | 
            \ setlocal shiftwidth=2
augroup end

""" Color scheme 
syntax on
if $THEME != "dark" && $TERM != "st-256color"
    set bg=light
else
    set bg=dark
endif
colorscheme gruvbox

" Fix gruvbox colors by using 24-bit (true-color) mode in Vim/Neovim
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
    set termguicolors
endif

""" Statusline 
set laststatus=2
"let g:airline_theme='gruvbox'
set noshowmode  " remove the '-- INSERT --'

""" line numbers 
set relativenumber number
highlight LineNr guifg=#DDA500
highlight CursorColumn guibg=#122222

""" Indentation
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set smartindent

""" Search 
set incsearch hlsearch "":noh to undo the current search highlight
set ignorecase
set smartcase

""" Other 
set scrolloff=10
set splitbelow splitright
set wildmode=longest,list,full

""" Keybindings
let mapleader=" "
inoremap jk <escape>

" Visuals
nnoremap <leader>h :noh<CR>
nnoremap <leader>l :set nocursorcolumn<CR>
nnoremap <leader>L :set cursorcolumn<CR>

" Copy and paste
noremap <C-c> "+y
nnoremap <C-p> "+p
nnoremap Y y$

" Navigation splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resizing splits
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

