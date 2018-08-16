" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

set t_Co=256
colorscheme molokai

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
"else
  "set backup		" keep a backup file
"endif
"
set history=50		" keep 50 lines of command line history
"set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  set nocp
  filetype plugin indent on
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  " autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType python setlocal omnifunc=RopeCompleteFunc
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType javascript set omnifunc=tern#Complete

  autocmd FileType python setlocal commentstring=#\ %s

  let g:cssColorVimDoNotMessMyUpdatetime = 1
  autocmd FileType html,css,php EmmetInstall

  "autocmd BufWritePost *.c,*h,*.cpp silent call UpdateCscope()

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  au BufEnter *.cpp,*.c,*.h call Open101Check()
  au BufLeave *.cpp,*.c,*.h call Close101Check()

  augroup END

  augroup VimCSS3Syntax
      autocmd!
      autocmd FileType css setlocal iskeyword+=-
  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

inoremap <C-k> <C-x><C-o>
inoremap {<CR> {<CR>}<ESC>ko
nnoremap <C-n> :w<CR>:bn<CR>
nnoremap <A-n> :w<CR>:bN<CR>
nnoremap <C-H> :A<CR>
nnoremap <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nnoremap <C-S> :w<CR>
nnoremap <C-C> y

set tabstop=4
set shiftwidth=4
set expandtab
set nu
set cul
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set fileencoding=utf-8  
set encoding=utf-8
set colorcolumn=100
map<F6> :vertical-res +5<CR>
map<F7> :vertical-res -5<CR>
map<F5> :call Openvimrc()<CR>
func! Openvimrc()
    exec 'w'
    exec 'e ~/.vimrc'
endfunc
" nnoremap<F2> :call Run()<CR>
nnoremap<F2> <C-]>
nnoremap<C-F2> g<C-]>

func!Open101Check()
    if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'h'
        if !exists('w:m2') 
            let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1, 101)
        endif
    endif
endfunc

func!Close101Check()
    if exists('w:m2') 
        call matchdelete(101)
        unlet w:m2
    endif
endfunc

func!Run()
	exec 'w'
    if &filetype == 'sh'
        exec '!clear && ./%'
    elseif &filetype == 'c'
		exec '!clear && gcc % -o %.obj && ./%.obj'
    elseif &filetype == 'c' || &filetype == 'cpp'
		exec '!clear && g++ % -o %.obj && ./%.obj'
	elseif &filetype == 'python'
        if expand('%:e') == 'py'
            exec '!clear && python %'
        elseif expand('%:e') == 'vertx'
            exec '!clear && vertx run %.py'
        endif
	elseif &filetype == 'java'
		exec '!clear && javac % && java %<'
	elseif &filetype == 'lua'
		exec '!clear && $LUA %'
    elseif &filetype == 'php'
        exec '!clear && php %'
    elseif &filetype == 'javascript'
        exec '!clear && node %'
	endif
endfunc

function!UpdateCscope()
    set nocsverb

    if !filereadable('./cscope.out')
        return
    endif

    cs kill -1 
    exec ''
    exec '!cscope -Rbkq'
    cs add cscope.out 
    exec ''
endfunc

cs add /e/code/baidu/duer/cscope.out /e/code/baidu/duer/

" filetype plugin on
let g:user_emmet_install_global = 0
"let g:user_emmet_leader_key='<C-D>'
let g:user_emmet_expandabbr_key='<C-e>'
" let g:user_emmet_settings={
" \'php':{
    " \'extends':'html',
    " \'filters':'c',
" \},
" \'xml':{
    " \'extends':'html',
" \},
" \}
 
"nnoremap<C-O> :NERDTreeToggle<CR>
let NERDTreeMouseMode = 3

set tags+=/home/lisijun/Ccode/stl/tags
set tags+=.tags
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1 
let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表 
let OmniCpp_MayCompleteDot = 1   " 输入 .  后自动补全
let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全 
let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全 
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" 自动关闭补全窗口 
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif 
set completeopt=menuone,menu,longest

" ctrlp config
set laststatus=2
let g:ctrlp_max_height = 30
set nofoldenable

" ropevim config
let ropevim_vim_completion=1
let ropevim_extended_complete=1
let ropevim_enable_autoimport=1
let ropevim_enable_shortcuts=1
let ropevim_guess_project=1
let ropevim_open_files_in_tabs=1
let ropevim_goto_def_newwin='vnew'
" let pymode_rope_goto_definition_cmd='e'
" set <M-/>=/
" set <M-?>=?

" tern_for_vim config
let tern_show_signature_in_pum = 1

" powerline config
" let g:Powerline_symbols='fancy'

" JSHint config
let jshint2_read = 1
let jshint2_save = 1
let jshint2_close = 1 " auto close orphaned error lists.
let jslint2_confirm = 0
let jslint2_color = 1 " use colored messages.
let jslint2_error = 1 " enable error code.
let jslint2_min_height = 3
let jslint2_max_height = 12

" Syntastic config
set statusline=%f%h%m%r\ (%{strftime(\"%d/%m/%Y\ %H:%M\",getftime(expand(\"%:p\")))})%=Line\ %l\/%L(%p%%),\ Col\ %-4v\ [%{&ff}]
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1

" settings for git bash show block cursor
let &t_ti.="\e[2 q"
let &t_SI.="\e[6 q"
let &t_EI.="\e[2 q"
let &t_te.="\e[0 q"

execute pathogen#infect()

func! Build()
    exec '!mbed compile --source lightduer-os-for-mbed-demo --source mbed-os/ --source lightduer-os-for-mbed --source libduer-device/ -t ARM -m UNO_81C -DCUSTOM_SSID=\"iottest\" -DCUSTOM_PASSWD=\"12345678\" -DENABLE_ALERT -DMBED_HEAP_STATS_ENABLED -DUSE_ALERT_FLASH '
    "exec '!mbed compile --source lightduer-os-for-mbed-demo --source mbed-os/ --source lightduer-os-for-mbed --source libduer-device/ -t ARM -m UNO_81C -DCUSTOM_SSID=\"Jt9Y9482\" -DCUSTOM_PASSWD=\"p1Ebh3NcbBoXbsuX\" -DENABLE_ALERT -DMBED_HEAP_STATS_ENABLED -DUSE_ALERT_FLASH '
endfunc

func! Buildc()
    exec '!mbed compile --source lightduer-os-for-mbed-demo --source mbed-os/ --source lightduer-os-for-mbed --source libduer-device/ -t ARM -m UNO_81C -DCUSTOM_SSID=\"iottest\" -DCUSTOM_PASSWD=\"12345678\" -DENABLE_ALERT -DMBED_HEAP_STATS_ENABLED -DUSE_ALERT_FLASH  -c'
    "exec '!mbed compile --source lightduer-os-for-mbed-demo --source mbed-os/ --source lightduer-os-for-mbed --source libduer-device/ -t ARM -m UNO_81C -DCUSTOM_SSID=\"Jt9Y9482\" -DCUSTOM_PASSWD=\"p1Ebh3NcbBoXbsuX\" -DENABLE_ALERT -DMBED_HEAP_STATS_ENABLED -DUSE_ALERT_FLASH  -c'
endfunc

command! -n=0 Build :call Build()
command! -n=0 Buildc :call Buildc()
command! -n=0 Update :call UpdateCscope()

