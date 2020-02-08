set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

set number
let g:NERDTreeWinPos = "left"
//autocmd VimEnter * NERDTree
//autocmd VimEnter * wincmd p
//autocmd BufWinEnter * NERDTreeMirror
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
nmap <F6> :NERDTreeToggle<CR>

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': './install --bin'  }
Plug 'junegunn/fzf.vim'
call plug#end()"

execute pathogen#infect()

