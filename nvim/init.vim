set nu rnu

if &compatible
  set nocompatible
endif


set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

	
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#add('itchyny/lightline.vim')
  call dein#add('arzg/vim-colors-xcode')
  call dein#add('vim-scripts/octave.vim--')
  call dein#add('skywind3000/vim-quickui')


  call dein#end()
  call dein#save_state()
endif


filetype plugin indent on
syntax enable

"Pgo support
"A file extension invented by me that means go to preprocess
if has("autocmd")
  autocmd BufNewFile,BufRead *.pgo set syntax=go
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"Octave support
augroup filetypedetect
  au! BufRead,BufNewFile *.m,*.oct set filetype=octave
augroup END 

"Always Markdown highlight
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
"Alway LaTeX Highlight
au BufNewFile,BufFilePre,BufRead *.tex set filetype=tex

"Colorscheme
colo xcodedark

"POP
"set fo=aw2t expandtab "sw=2 tw=100

"Spell check
set spell
set spell spelllang=en_us
command -nargs=1 SpellLang set spell spelllang=<args>
map <leader>ss :setlocal spell!<cr>

"I don't like this but i can't find a more secure way
if filereadable(".vimrc")
  so .vimrc
endif

