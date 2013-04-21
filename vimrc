filetype plugin indent on
syntax on
set backupcopy=no
set nowrap
set textwidth=72
set modeline
set nojoinspaces
set number

set title

set guioptions-=T

set wildmenu
set wildmode=longest:full

"Color scheme
"colors molokai
"colors earendel
"colors gentooish
"colors inkpot
"colors jellybeans
"colors liquidcarbon
"colors moria
"colors nu42dark
"colors twilight
"colors wombat
"colors zenburn

"tags settings"
set tags=./tags;/work

"TagList configuration
let &updatetime = 1000
let Tlist_Ctags_Cmd ="/usr/bin/ctags-exuberant"
let Tlist_WinWidth = 30
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1

" Key mapping
inoremap <C-Space> <C-X><C-O>
noremap! <C-BS> <C-W>
nnoremap <silent> <Tab> :TlistToggle<CR>
map <C-F> :tabprev<CR>

"Cscope autoloading
function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose " suppress 'duplicate connection' error
        exe "cs add " . db . " " . path
        set cscopeverbose
    endif
endfunction
au BufEnter /* call LoadCscope()
"recomanded to use
map [I :cs find c <C-r><C-w><CR>
set csto=1

"Resize window while vsplit
if bufwinnr(1)
    map + <C-W>>
    map - <C-W><
    map ] <C-W>+
    map [ <C-W>-
endif

"Different coloscheme for vimdiff
if &diff
    colorscheme zenburn
endif

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
            if expl_win_num != -1
                let cur_win_nr = winnr()
                exec expl_win_num . 'wincmd w'
                close
                exec cur_win_nr . 'wincmd w'
                unlet t:expl_buf_num
            else
                unlet t:expl_buf_num
            endif
    else
        exec '1wincmd w'
        Vexplore
        let t:expl_buf_num = bufnr("%")
    endif
endfunction
 map <silent> <C-E> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
"*g:netrw_browse_split* when browsing, <cr> will open the file by:
"                =0: re-using the same window
"                =1: horizontally splitting the window first
"                =2: vertically   splitting the window first
"                =3: open file in new tab
"                =4: act like "P" (ie. open previous window)
"                    Note that |g:netrw_preview| may be used
"                    to get vertical splitting instead of
"                    horizontal splitting.
let g:netrw_browse_split  = 0
let g:netrw_altv          = 1
let g:netrw_winsize       = 15

"Folding type / folding map to space
" Note, perl automatically sets foldmethod in the syntax file
autocmd Syntax c,cpp,vim,xml,html,xhtml setlocal foldmethod=syntax
autocmd Syntax c,cpp,vim,xml,html,xhtml,perl normal zR
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Highlight the trailing whitespace
"highlight TrailingWhitespace ctermbg=red guibg=red
"autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
" match TrailingWhiteSpace /\s\+\%#\@<!$/

"highlight TrailingWhitespace ctermbg=white guibg=white
"autocmd ColorScheme * highlight TrailingWhitespace ctermbg=white guibg=white
"match TrailingWhitespace /\s\+\%#\@<!$/
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Highlight long lines
"highlight LongLine ctermbg=lightblue guibg=lightblue
"autocmd ColorScheme * highlight LongLine ctermbg=lightblue guibg=lightblue
highlight LongLine ctermbg=white guibg=white
autocmd ColorScheme * highlight LongLine ctermbg=white guibg=white

match LongLine /\%>80v.\+/

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

autocmd FileType * set tabstop=4 shiftwidth=4 expandtab softtabstop=4
			\ textwidth=0 nospell
autocmd BufEnter * let &titlestring = substitute(getcwd(), ".*/", "", "")
			\ . " - " . expand("%")

" text
autocmd BufEnter *.txt set spell tabstop=4 shiftwidth=4 noexpandtab
			\ softtabstop=4 textwidth=72 autoindent

" send-email cover letter
autocmd BufEnter .gitsendemail.msg.* set spell tabstop=4 shiftwidth=4 noexpandtab
			\ softtabstop=4 textwidth=72 autoindent

" mutt file
autocmd BufEnter */tmp/mutt-* set spell tabstop=4 shiftwidth=4 noexpandtab
			\ softtabstop=4 textwidth=72 autoindent

" assembly files
autocmd BufEnter *.{S,s} set filetype=c

" C/C++
autocmd FileType c,cpp set textwidth=78 cinoptions=(0,:0)

" Android.mk
autocmd FileType *.mk set tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
			\ textwidth=78

" Python
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab softtabstop=4
			\ textwidth=78
let python_highlight_all = 1

" Shell
autocmd FileType sh set textwidth=78

" Kconfig
autocmd FileType kconfig set textwidth=72 formatoptions+=t autoindent nospell

" Git commit message edit
autocmd BufEnter .git/COMMIT_EDITMSG set spell textwidth=72 formatoptions+=t

" Git grep
command! -complete=file -nargs=+ GitGrep
	\ cexpr system('git grep -n <args>')

" The Linux checkpatch.pl script
command! -complete=file -nargs=+ CheckPatch
	\ cexpr system('./scripts/checkpatch.pl --terse <args>')

" Linux building
command! -nargs=+ -complete=file LinuxBuild
	\ make! -j4 ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi-
	\ O=<args> uImage

command! InsertAsmHeader execute
	\ "normal ggi/*\n" .
	\ " * "expand("%") . "\n" .
	\ " *\n" .
	\ " * Copyright (C) " . strftime("%Y") . "\n" .
	\ " * Author: Serban Constantinescu <serbancon@gmail.com>\n" .
	\ " *\n" .
    \ " * Redistribution and use in source and binary forms, with or without\n" .
    \ " * modification, are not permitted!\n" .
    \ " *\n" .
    \ " * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\n" .
    \ " * \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\n" .
    \ " * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS\n" .
    \ " * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE\n" .
    \ " * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,\n" .
    \ " * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,\n" .
    \ " * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS\n" .
    \ " * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED\n" .
    \ " * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n" .
    \ " * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT\n" .
    \ " * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF\n" .
    \ " * SUCH DAMAGE.\n" .
    \ " */" .
    \ "\n"


command! InsertCHeader execute
	\ "normal ggi/*\n" .
	\ expand("%") . "\n" .
	\ "\n" .
	\ "Copyright (C) " . strftime("%Y") . "\n" .
	\ "Author: Serban Constantinescu <serbancon@gmail.com>\n" .
	\ "\n" .
    \ "Redistribution and use in source and binary forms, with or without\n" .
    \ "modification, are not permitted!\n" .
    \ "\n" .
    \ "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\n" .
    \ "\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\n" .
    \ "LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS\n" .
    \ "FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE\n" .
    \ "COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,\n" .
    \ "INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,\n" .
    \ "BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS\n" .
    \ "OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED\n" .
    \ "AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n" .
    \ "OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT\n" .
    \ "OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF\n" .
    \ "SUCH DAMAGE.\n" .
    \ "/" .
    \ "\n"


command! InsertSignedOff execute "normal iSigned-off-by: Serban Constantinescu <serbancon@gmail.com>"
command! InsertReviewed execute "normal iReviewed-by: Serban Constantinescu <serbancon@gmail.com>"
command! InsertAcked execute "normal iAcked-by: Serban Constantinescu <serbancon@gmail.com>"
command! InsertTested execute "normal iTested-by: Serban Constantinescu <serbancon@gmail.com>"

autocmd BufNewFile *.c,*.h,*.cpp,*.hpp,*.cc, InsertCHeader
autocmd BufNewFile *.s,*.S InsertAsmHeader

" Addr2Line
function GetLineAndFunc(output)
	let fllist = split(a:output)
	let res = []
	let i = 0
	echo len(fllist)
	while i < len(fllist)
		let res += [fllist[i + 1] . ': ' . fllist[i]]
		let i += 2
	endwhile
	return res
endfunction

command! -nargs=+ -complete=file Addr2Line
	\ cexpr GetLineAndFunc(system('arm-none-linux-gnueabi-addr2line -i -f -e <args>'))
