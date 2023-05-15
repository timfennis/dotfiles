set runtimepath^=~/.vim runtimepath+=/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Load/install various plugins
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
call plug#end()

" Setup language client with rust
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ }
