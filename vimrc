set shell="C:\Program Files\ConEmu\ConEmu64.exe"
set nocompatible
"these come with windows vim
"commenting out so I learn universally
"source $VIMRUNTIME/vimrc_example.vim
"lots of windows custom mappings, borrowing backspace fix && Ctrl-c/x/v, see below
"source $VIMRUNTIME/mswin.vim 
"behave mswin

set diffexpr=MyDiff()

colorscheme mustang

autocmd VimEnter * NERDTree C:\~Stg\Projects\

syntax on
set tabstop=4 "4 spaces with Tab
set shiftwidth=4 " 4 spaces with >
set number
set relativenumber
set belloff=all
set hlsearch "highlighting for search pattern
set guifont=Consolas:h9:cANSI

if has('win32')
	"airline/powerline settings
	let g:Powerline_symbols = 'fancy'
	let g:airline_powerline_fonts = 1
	set encoding=utf-8 "crucial for powerline fonts
	set laststatus=2 "keeps airline enabled without split

	set termencoding=utf8
	set term=xterm

	"pulling from mswin.vim
	"backspace fixes
	set backspace=indent,eol,start whichwrap+=<,>,[,]
	vnoremap <BS> D
	"windows copy/paste setup
	"CTRL-X is Cut?
	vnoremap <C-X> "+x
	"CTRL-C is copy
	vnoremap <C-C> "+y
	map <C-V> "+gP
	cmap <C-V> <C-R>+
	exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
	exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
	noremap <C-Q> <C-V>

	if !has('gui_running')
		set t_Co=256
		let &t_AB="\e[48;5;%dm"
		let &t_AF="\e[38;5;%dm"

		"fix for ConEmu backspace key mapping
		inoremap <Char-0x07F> <BS>
		nnoremap <Char-0x07F> <BS>
		set mouse=a
		"fix for ConEmu scroll wheel mapping	
		inoremap <Esc>[62~ <C-X><C-E>
		inoremap <Esc>[62~ <C-X><C-Y>
		nnoremap <Esc>[62~ <C-E>
		nnoremap <Esc>[63~ <C-Y>
	endif

	if has('gui_running')
		set guioptions -=m
		set guioptions -=T
		set guioptions -=r
		set guioptions -=L
	endif

	set undodir=$HOME\vimfiles\history
	set backupdir=$HOME\vimfiles\history
	set directory=$HOME\vimfiles\history

	function MyDiff()
	  let opt = '-a --binary '
	  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	  let arg1 = v:fname_in
	  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	  let arg2 = v:fname_new
	  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	  let arg3 = v:fname_out
	  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	  if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
		  if empty(&shellxquote)
			let l:shxq_sav = ''
			set shellxquote&
		  endif
		  let cmd = '"' . $VIMRUNTIME . '\diff"'
		else
		  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	  else
		let cmd = $VIMRUNTIME . '\diff'
	  endif
	  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
	  if exists('l:shxq_sav')
		let &shellxquote=l:shxq_sav
	  endif
	endfunction
endif

