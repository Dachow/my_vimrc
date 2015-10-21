" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif
 
" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
" -----------------------------------------------------------------------------

" Basic options {{{

    set nocompatible              " be iMproved, required
    filetype off                  " required


if g:iswindows
    set rtp+=$VIMRUNTIME/../vimfiles/bundle/Vundle.vim/
    call vundle#begin('$VIMRUNTIME/../vimfiles/bundle')
endif

if g:islinux
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

    "{{{ Python快捷键
    nnoremap <F5> :!python %
    nnoremap <F4> :!python
    "}}}

    set shiftwidth=4
    set expandtab
    "set t_Co=256
    syntax enable
    set ts=4
    set nu!
    syntax on

if g:isGUI
    set guioptions-=m " 隐藏菜单栏 
    set guioptions-=T " 隐藏工具栏 
    "set guioptions-=L " 隐藏左侧滚动条 
    "set guioptions-=r " 隐藏右侧滚动条 
    "set guioptions-=b " 隐藏底部滚动条 
    "set showtabline=0 " 隐藏Tab栏
endif

if g:iswindows 
    set linespace=5    "设置行间距
    set guifont=Consolas:h12
    au GUIEnter * simalt ~x " 窗口启动时自动最大化 
endif

if g:islinux
    set guifont=DejaVu\ Sans\ mono\ 11     "更改字体大小，反斜线后面有个空格
endif

    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin

    set fileencoding=chinese
    set fileencodings=utf-8,chinese,latin-1
    set termencoding=utf-8
    set encoding=utf-8


if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/delmenu.vim    "解决菜单乱码
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8    "解决consle输出乱码
endif

" }}} Basic options end


" Plugin settings {{{
    " Vundle {{{

        " let Vundle manage Vundle, required
        Plugin 'VundleVim/Vundle.vim'


        Plugin 'Yggdroot/indentLine'
        Plugin 'scrooloose/nerdtree'
        Plugin 'Valloric/MatchTagAlways'
        Plugin 'vim-scripts/taglist.vim'
        Plugin 'mattn/emmet-vim'
        Plugin 'jiangmiao/auto-pairs'
        Plugin 'fholgado/minibufexpl.vim'
        Plugin 'scrooloose/syntastic'
        Plugin 'bling/vim-airline'
        Plugin 'Dachow/winmanager'
        Plugin 'Dachow/visualmark'
        Plugin 'scrooloose/nerdcommenter'
        Plugin 'sjas/csExplorer'
        Plugin 'vim-scripts/xterm16.vim'
        Plugin 'altercation/vim-colors-solarized'
        "Plugin 'flazz/vim-colorschemes'

    if g:iswindows
        Plugin 'ervandew/supertab'
        Plugin 'Shougo/neocomplete.vim'
        "Plugin 'rkulla/pydiction'
        Plugin 'klen/python-mode'
    endif

    if g:islinux
        Plugin 'Valloric/YouCompleteMe'
    endif

" All of your Plugins must be added before the following line
call vundle#end()            " required

    " }}} Vundle end
    

    " indentLine {{{   
        set list lcs=tab:\|\ 
        "缩进对齐线
    " }}}

    " taglist {{{
        let Tlist_Show_One_File=1
        let Tlist_Exit_OnlyWindow=1
    " }}}

    " winmanager {{{
        let g:winManagerWindowLayout='FileExplorer|TagList'
        nmap wm :WMToggle<cr>
    " }}}

    " xterm16 {{{
        colo xterm16   
        hi MatchParen ctermbg=DarkCyan ctermfg=white
        hi MatchParen guibg=DarkCyan guifg=white
    " }}}

if g:iswindows
    " pydicition {{{
        "let g:pydiction_location = '$VIMRUNTIME/../vimfiles/bundle/pydiction/complete-dict'
    " }}}

    " neocomplete {{{
        let g:neocomplete#enable_at_startup = 1
    " }}}
endif

if g:islinux
    " YouCompleteMe {{{
        let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    "}}}
endif


" Plugin settings end }}}
    

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

if g:iswindows
    set diffexpr=MyDiff()
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
      let eq = ''
      if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
          let cmd = '"' . $VIMRUNTIME . '\diff"'			"修改过，原cmd=‘“”’
          let eq = '""'                         			"修改过，原eq=‘“’
        else
          let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
      else
        let cmd = $VIMRUNTIME . '\diff'
      endif
      silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

