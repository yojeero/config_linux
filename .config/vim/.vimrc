" =========================================
" fish shell compatibility fix
" =========================================
" Vim will use standard sh for system calls and filters (like :.!sh),
" which will prevent any syntax errors within Vim itself.
if &shell =~# 'fish$'
    set shell=/bin/sh
endif

" =========================================
" basic editor settings
" =========================================

set nocompatible    
syntax on           
set number          
set encoding=utf-8  
set mouse=a         

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

set hlsearch        
set incsearch       

" ==========================================
" GRUVBOX SOFT
" ==========================================
set termguicolors     

let &t_SI = "\e[6s\e[5 q"            
let &t_EI = "\e[6s\e[2 q"            

set background=dark                 
let g:gruvbox_contrast_dark='soft'  
colorscheme gruvbox                
