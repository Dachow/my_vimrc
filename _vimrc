" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================

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


" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
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
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
else
    set rtp+=$VIMRUNTIME/../vimfiles/bundle/Vundle.vim/
    call vundle#begin('$VIMRUNTIME/../vimfiles/bundle')
endif

" 使用Vundle来管理插件，这个必须要有。
Plugin 'VundleVim/Vundle.vim'

" 以下为要安装或更新的插件，不同仓库都有（具体书写规范请参考帮助）
        Plugin 'Yggdroot/indentLine'
        Plugin 'scrooloose/nerdtree'
        Plugin 'Valloric/MatchTagAlways'
        Plugin 'mattn/emmet-vim'
        Plugin 'jiangmiao/auto-pairs'
        Plugin 'fholgado/minibufexpl.vim'
        Plugin 'bling/vim-airline'
        " Plugin 'Dachow/visualmark'
        " Plugin 'scrooloose/nerdcommenter'
        " Plugin 'sjas/csExplorer'
        Plugin 'vim-scripts/xterm16.vim'
        Plugin 'majutsushi/tagbar'
        " Plugin 'klen/python-mode'
        " Plugin 'altercation/vim-colors-solarized'
        " Plugin 'tomasr/molokai'
        " Plugin 'tyru/open-browser.vim'
        " Plugin 'davidhalter/jedi-vim'
        Plugin 'ervandew/supertab'
        Plugin 'Shougo/neocomplete.vim'
        " Plugin 'asins/vimcdoc'
        " Plugin 'Valloric/YouCompleteMe'
        " Plugin 'scrooloose/syntastic'
        Plugin 'easymotion/vim-easymotion'
        Plugin 'kshenoy/vim-signature'
        " Plugin 'SirVer/ultisnips'
        Plugin 'kien/ctrlp.vim'
        Plugin 'Shougo/neosnippet'
        Plugin 'Shougo/neosnippet-snippets'
        " Plugin 'honza/vim-snippets'
        Plugin 'kristijanhusak/vim-hybrid-material'
        " Plugin 'skammer/vim-css-color'
        Plugin 'sheerun/vim-polyglot'

call vundle#end()                                     "All of your Plugins must be added before the following line

" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
set foldenable                                        "启用折叠
set foldmethod=indent                                 "indent 折叠方式
" set foldmethod=marker                                "marker 折叠方式

" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" 当文件在外部被修改，自动更新该文件
set autoread

" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>

" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

" Ctrl + K 插入模式下光标向上移动
imap <c-k> <Up>

" Ctrl + J 插入模式下光标向下移动
imap <c-j> <Down>

" Ctrl + H 插入模式下光标向左移动
imap <c-h> <Left>

" Ctrl + L 插入模式下光标向右移动
imap <c-l> <Right>

" Ctrl + o 插入模式下换行
imap <c-o> <c-[>o

" 调用chrome
nnoremap <F2> :!start chrome %<CR>

" Python快捷键
nnoremap <F5> :!python %<CR>
nnoremap <F4> :!start python<CR>

" <F7>生成ctags
nnoremap <F9> :!ctags -R<CR>

" 缓冲区映射
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>

" U 来撤销u的回退 <c-r>撤销对整行的更改
nnoremap U <c-r>
nnoremap <c-r> U

" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
" au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

" -----------------------------------------------------------------------------
"  < 界面配置 >
" -----------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
" set cmdheight=2                                       "设置命令行的高度为2，默认为1
" set cursorline                                        "突出显示当前行
set nowrap                                            "设置不自动换行
set linespace=5                                       "设置行间距
set guifont=Consolas:h11                              "设置字体字号
set guifontwide=YouYuan:h11
" set shortmess=atI                                     "去掉欢迎界面

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " au GUIEnter * simalt ~x                           "窗口启动时自动最大化
    winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=38 columns=120                          "指定窗口大小，lines为高度，columns为宽度
endif

if g:islinux
    set linespace=3
    set guifont=DejaVu\ Sans\ Mono\ 11     "更改字体大小，反斜线后面有个空格
    set lines=999   "columns=118  窗口最大化
    " sudo apt-get install wmctrl
    function! ToggleFullScreen()
        call system("wmctrl -r :ACTIVE: -b toggle,fullscreen")
    endfunction
    map <silent> <F11> :call ToggleFullScreen()<CR>
endif

" 设置代码配色方案
if g:isGUI
    colo hybrid_material
    "colo hybrid_reverse
    hi SignColumn guibg=#263238
    hi Folded guibg=#171717 guifg=#999999
else
    colo xterm16   
    hi MatchParen ctermbg=DarkCyan ctermfg=white
    hi MatchParen guibg=DarkCyan guifg=white
    hi Comment ctermbg=Black ctermfg=DarkGreen 
    hi Comment guibg=Black guifg=SeaGreen 
endif
    hi Comment cterm=italic gui=italic

" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nmap <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

" 设置补全配置
set completeopt-=preview               " Disable preview scratch window
set pumheight=17                       " Limit popup menu height

" -----------------------------------------------------------------------------
"  < 在浏览器中预览 Html 或 PHP 文件 >
" -----------------------------------------------------------------------------
" 修改前请先通读此模块，明白了再改以避免错误

" F3 加浏览器名称缩写调用浏览器预览，启用前先确定有安装相应浏览器，并在下面的配置好其安装目录
if g:iswindows
    "以下为只支持Windows系统的浏览器

    " 调用系统IE浏览器预览，如果已卸载可将其注释
    nmap <F3>ie :call ViewInBrowser("ie")<cr>
    imap <F3>ie <ESC>:call ViewInBrowser("ie")<cr>

    " 调用IETester(IE测试工具)预览，如果有安装可取消注释
    " nmap <F5>ie6 :call ViewInBrowser("ie6")<cr>
    " imap <F5>ie6 <ESC>:call ViewInBrowser("ie6")<cr>
    " nmap <F5>ie7 :call ViewInBrowser("ie7")<cr>
    " imap <F5>ie7 <ESC>:call ViewInBrowser("ie7")<cr>
    " nmap <F5>ie8 :call ViewInBrowser("ie8")<cr>
    " imap <F5>ie8 <ESC>:call ViewInBrowser("ie8")<cr>
    " nmap <F5>ie9 :call ViewInBrowser("ie9")<cr>
    " imap <F5>ie9 <ESC>:call ViewInBrowser("ie9")<cr>
    " nmap <F5>ie10 :call ViewInBrowser("ie10")<cr>
    " imap <F5>ie10 <ESC>:call ViewInBrowser("ie10")<cr>
    " nmap <F5>iea :call ViewInBrowser("iea")<cr>
    " imap <F5>iea <ESC>:call ViewInBrowser("iea")<cr>
elseif g:islinux
    "以下为只支持Linux系统的浏览器
    "暂未配置，待有时间再弄了
endif

"以下为支持Windows与Linux系统的浏览器

" 调用Firefox浏览器预览，如果有安装可取消注释
" nmap <F5>ff :call ViewInBrowser("ff")<cr>
" imap <F5>ff <ESC>:call ViewInBrowser("ff")<cr>

" 调用Maxthon(遨游)浏览器预览，如果有安装可取消注释
" nmap <F5>ay :call ViewInBrowser("ay")<cr>
" imap <F5>ay <ESC>:call ViewInBrowser("ay")<cr>

" 调用Opera浏览器预览，如果有安装可取消注释
" nmap <F5>op :call ViewInBrowser("op")<cr>
" imap <F5>op <ESC>:call ViewInBrowser("op")<cr>

" 调用Chrome浏览器预览，如果有安装可取消注释
" nmap <F5>cr :call ViewInBrowser("cr")<cr>
" imap <F5>cr <ESC>:call ViewInBrowser("cr")<cr>

" 浏览器调用函数
function! ViewInBrowser(name)
    if expand("%:e") == "php" || expand("%:e") == "html"
        exe ":update"
        if g:iswindows
            "获取要预览的文件路径，并将路径中的'\'替换为'/'，同时将路径文字的编码转换为gbk（同cp936）
            let file = iconv(substitute(expand("%:p"), '\', '/', "g"), "utf-8", "gbk")

            "浏览器路径设置，路径中使用'/'斜杠，更改路径请更改双引号里的内容
            "下面只启用了系统IE浏览器，如需启用其它的可将其取消注释（得先安装，并配置好安装路径），也可按需增减
            let SystemIE = "C:/progra~1/intern~1/iexplore.exe"  "系统自带IE目录
            " let IETester = "F:/IETester/IETester.exe"           "IETester程序目录（可按实际更改）
            " let Chrome = "F:/Chrome/Chrome.exe"                 "Chrome程序目录（可按实际更改）
            " let Firefox = "F:/Firefox/Firefox.exe"              "Firefox程序目录（可按实际更改）
            " let Opera = "F:/Opera/opera.exe"                    "Opera程序目录（可按实际更改）
            " let Maxthon = "C:/Progra~2/Maxthon/Bin/Maxthon.exe" "Maxthon程序目录（可按实际更改）

            "本地虚拟服务器设置，我测试的是phpStudy2014，可根据自己的修改，更改路径请更改双引号里的内容
            let htdocs ="F:/phpStudy2014/WWW/"                  "虚拟服务器地址或目录（可按实际更改）
            let url = "localhost"                               "虚拟服务器网址（可按实际更改）
        elseif g:islinux
            "暂时还没有配置，有时间再弄了。
        endif

        "浏览器调用缩写，可根据实际增减，注意，上面浏览器路径中没有定义过的变量（等号右边为变量）不能出现在下面哟（可将其注释或删除）
        let l:browsers = {}                             "定义缩写字典变量，此行不能删除或注释
        " let l:browsers["cr"] = Chrome                   "Chrome浏览器缩写
        " let l:browsers["ff"] = Firefox                  "Firefox浏览器缩写
        " let l:browsers["op"] = Opera                    "Opera浏览器缩写
        " let l:browsers["ay"] = Maxthon                  "遨游浏览器缩写
        let l:browsers["ie"] = SystemIE                 "系统IE浏览器缩写
        " let l:browsers["ie6"] = IETester."-ie6"         "调用IETESTER工具以IE6预览缩写（变量加参数）
        " let l:browsers["ie7"] = IETester."-ie7"         "调用IETESTER工具以IE7预览缩写（变量加参数）
        " let l:browsers["ie8"] = IETester."-ie8"         "调用IETESTER工具以IE8预览缩写（变量加参数）
        " let l:browsers["ie9"] = IETester."-ie9"         "调用IETESTER工具以IE9预览缩写（变量加参数）
        " let l:browsers["ie10"] = IETester."-ie10"       "调用IETESTER工具以IE10预览缩写（变量加参数）
        " let l:browsers["iea"] = IETester."-al"          "调用IETESTER工具以支持的所有IE版本预览缩写（变量加参数）

        if stridx(file, htdocs) == -1   "文件不在本地虚拟服务器目录，则直接预览（但不能解析PHP文件）
           exec ":silent !start ". l:browsers[a:name] ." file://" . file
        else    "文件在本地虚拟服务器目录，则调用本地虚拟服务器解析预览（先启动本地虚拟服务器）
            let file = substitute(file, htdocs, "http://".url."/", "g")    "转换文件路径为虚拟服务器网址路径
            exec ":silent !start ". l:browsers[a:name] file
        endif
    else
        echohl WarningMsg | echo " please choose the correct source file"
    endif
endfunction

" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
" set noswapfile                              "设置无临时文件
" set vb t_vb=                                "关闭提示音


" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < indentLine 插件配置 >
" -----------------------------------------------------------------------------
" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
" 开启/关闭对齐线
nmap <leader>il :IndentLinesToggle<CR>

" 设置Gvim的对齐线样式
if g:isGUI
    let g:indentLine_char = "┊"
    let g:indentLine_first_char = "┊"
endif

" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_term = 239

" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
" let g:indentLine_color_gui = '#A4E57E'

" " -----------------------------------------------------------------------------
" "  < MiniBufExplorer 插件配置 >
" " -----------------------------------------------------------------------------
" " 快速浏览和操作Buffer
" " 主要用于同时打开多个文件并相与切换

" " let g:miniBufExplMapWindowNavArrows = 1     "用Ctrl加方向键切换到上下左右的窗口中去
" let g:miniBufExplMapWindowNavVim = 1        "用<C-k,j,h,l>切换到上下左右的窗口中去
" let g:miniBufExplMapCTabSwitchBufs = 1      "功能增强（不过好像只有在Windows中才有用）
" "                                            <C-Tab> 向前循环切换到每个buffer上,并在但前窗口打开
" "                                            <C-S-Tab> 向后循环切换到每个buffer上,并在当前窗口打开

" 在不使用 MiniBufExplorer 插件时也可用<C-k,j,h,l>切换到上下左右的窗口中去
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" -----------------------------------------------------------------------------
"  < nerdcommenter 插件配置 >
" -----------------------------------------------------------------------------
" 我主要用于C/C++代码注释(其它的也行)
" 以下为插件默认快捷键，其中的说明是以C/C++为例的，其它语言类似
" <Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
" <Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
" <Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
" <Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
" <Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）
" <Leader>cA 行尾注释
let NERDSpaceDelims = 1                     "在左注释符之后，右注释符之前留有空格

" -----------------------------------------------------------------------------
"  < nerdtree 插件配置 >
" -----------------------------------------------------------------------------
" 有目录村结构的文件浏览插件

" 常规模式下输入 F2 调用插件
nmap <F7> :NERDTreeToggle<CR>

" -----------------------------------------------------------------------------
"  < nerdtree & tagbar 插件配置 >
" -----------------------------------------------------------------------------
"  常规模式下<F8>同时打开 nerdtree 和 tagbar
if g:iswindows
    let g:NERDTreeWinSize = 31
    let g:tagbar_width = 40
endif
if g:islinux
    let g:NERDTreeWinSize = 23
    let g:tagbar_width = 28
endif

function! ToggleNERDTreeAndTagbar()
let w:jumpbacktohere = 1

Detect which plugins are open
if exists('t:NERDTreeBufName')
    let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
else
    let nerdtree_open = 0
endif
let tagbar_open = bufwinnr('__Tagbar__') != -1

" Perform the appropriate action
if nerdtree_open && tagbar_open
    NERDTreeClose
    TagbarClose
elseif nerdtree_open
    TagbarOpen
elseif tagbar_open
    NERDTree
else
    NERDTree
    TagbarOpen
endif

" Jump back to the original window
for window in range(1, winnr('$'))
    execute window . 'wincmd w'
    if exists('w:jumpbacktohere')
        unlet w:jumpbacktohere
        break
    endif
endfor
endfunction 

" close NERDTree with vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

nnoremap <F8> :call ToggleNERDTreeAndTagbar()<CR>

" -----------------------------------------------------------------------------
"  < pymode 插件配置 >
" -----------------------------------------------------------------------------
let g:pymode_rope_completion = 0               "关闭pymode补全
let g:pymode_lint_cwindow = 0                  "关闭顶部补全框 
let g:pymode_rope = 0                          "关闭rope模式

" -----------------------------------------------------------------------------
"  < supertab 插件配置 >
" -----------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = "context"
  
" -----------------------------------------------------------------------------
"  < neocomplete & jedi 插件配置 >
" -----------------------------------------------------------------------------
let g:neocomplete#enable_at_startup = 1

autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python =
\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" Alternative pattern: \ '\h\w*\|[^. \t]\.\w*'

" -----------------------------------------------------------------------------
"  < neosnippet 插件配置 >
" -----------------------------------------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<TAB>" : "\<Plug>(neosnippet_expand_or_jump)"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" -----------------------------------------------------------------------------
"  < repeat 插件配置 >
" -----------------------------------------------------------------------------
" 主要用"."命令来重复上次插件使用的命令

" -----------------------------------------------------------------------------
"  < ZoomWin 插件配置 >
" -----------------------------------------------------------------------------
" 用于分割窗口的最大化与还原
" 常规模式下按快捷键 <c-w>o 在最大化与还原间切换

" =============================================================================
"                          << 以下为常用工具配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < gvimfullscreen 工具配置 > 请确保已安装了工具
" -----------------------------------------------------------------------------
" 用于 Windows Gvim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
if (g:iswindows && g:isGUI)
    nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" -----------------------------------------------------------------------------
"  < vimtweak 工具配置 > 请确保以已装了工具
" -----------------------------------------------------------------------------
" 这里只用于窗口透明与置顶
" 常规模式下 Ctrl + Up（上方向键） 增加不透明度，Ctrl + Down（下方向键） 减少不透明度，<Leader>t 窗口置顶与否切换
if (g:iswindows && g:isGUI)
    let g:Current_Alpha = 255
    let g:Top_Most = 0
    func! Alpha_add()
        let g:Current_Alpha = g:Current_Alpha + 10
        if g:Current_Alpha > 255
            let g:Current_Alpha = 255
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Alpha_sub()
        let g:Current_Alpha = g:Current_Alpha - 10
        if g:Current_Alpha < 155
            let g:Current_Alpha = 155
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Top_window()
        if  g:Top_Most == 0
            call libcallnr("vimtweak.dll","EnableTopMost",1)
            let g:Top_Most = 1
        else
            call libcallnr("vimtweak.dll","EnableTopMost",0)
            let g:Top_Most = 0
        endif
    endfunc

    "快捷键设置
    nmap <c-up> :call Alpha_add()<CR>
    nmap <c-down> :call Alpha_sub()<CR>
    nmap <leader>t :call Top_window()<CR>
endif

" =============================================================================
"                          << 以下为常用自动命令配置 >>
" =============================================================================

" 自动切换目录为当前编辑文件所在目录
au BufRead,BufNewFile,BufEnter * cd %:p:h

" -----------------------------------------------------------------------------
"  < 文件头生成 >
" -----------------------------------------------------------------------------
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#########################################################################") 
        call append(line("."), "\# File Name: ".expand("%")) 
        call append(line(".")+1, "\# Author: xiaoFen") 
        call append(line(".")+2, "\# Mail: hellowd93@163.com") 
        call append(line(".")+3, "\# Created Time: ".strftime("%c")) 
        call append(line(".")+4, "\# Last Modified: ".strftime("%Y-%m-%d %X"))
        call append(line(".")+5, "\#########################################################################") 
        call append(line(".")+6, "\#!/bin/bash") 
        call append(line(".")+7, "") 
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: xiaoFen") 
        call append(line(".")+2, "    > Mail: hellowd93@163.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, "    > Last Modified: ".strftime("%Y-%m-%d %X"))
        call append(line(".")+5, " ************************************************************************/") 
        call append(line(".")+6, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+7, "#include<iostream>")
        call append(line(".")+8, "using namespace std;")
        call append(line(".")+9, "")
    endif
    if &filetype == 'c'
        call append(line(".")+7, "#include<stdio.h>")
        call append(line(".")+8, "")
    endif
endfunc

" python 文件头
autocmd BufNewFile *.py exec ":call SetPyTitle()"
func SetPyTitle()
    call setline(1, "#!/usr/bin/env python")
    call append(line("."), "# -*- coding: utf-8 -*-")
    call append(line(".")+1, "# -------------------------------------------------------------------------")
    call append(line(".")+2, "#    > File Name: ".expand("%"))
    call append(line(".")+3, "#    > Author: xiaoFen")
    call append(line(".")+4, "#    > Mail: hellowd93@163.com")
    call append(line(".")+5, "#    > Created Time: ".strftime("%Y-%m-%d %X"))
    call append(line(".")+6, "#    > Last Modified: ".strftime("%Y-%m-%d %X"))
    call append(line(".")+7, "# -------------------------------------------------------------------------")
    call append(line(".")+8, "")
endfunc

""实现上面函数中的，Last modified功能
"""""""""""""""""""""""""""""""""""""""""
autocmd BufWrite,BufWritePre,FileWritePre *.cpp,*.[ch],*.sh,*.java,*.py    ks|call LastModified()|'s  
func LastModified()
	if line("$") > 20
		let l = 20
	else 
		let l = line("$")
	endif
	exe "1,".l."g/Last Modified: /s/Last Modified: .*/Last Modified:".
			\strftime(" %Y-%m-%d %X" ) . "/e"
endfunc

"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G

" =============================================================================
"                     << windows 下解决 Quickfix 乱码问题 >>
" =============================================================================
" windows 默认编码为 cp936，而 Gvim(Vim) 内部编码为 utf-8，所以常常输出为乱码
" 以下代码可以将编码为 cp936 的输出信息转换为 utf-8 编码，以解决输出乱码问题
" 但好像只对输出信息全部为中文才有满意的效果，如果输出信息是中英混合的，那可能
" 不成功，会造成其中一种语言乱码，输出信息全部为英文的好像不会乱码
" 如果输出信息为乱码的可以试一下下面的代码，如果不行就还是给它注释掉

" if g:iswindows
"     function QfMakeConv()
"         let qflist = getqflist()
"         for i in qflist
"            let i.text = iconv(i.text, "cp936", "utf-8")
"         endfor
"         call setqflist(qflist)
"      endfunction
"      au QuickfixCmdPost make call QfMakeConv()
" endif

" =============================================================================
"                          << 其它 >>
" =============================================================================
" 注：上面配置中的"<Leader>"在本软件中设置为"\"键（引号里的反斜杠），如<Leader>t
" 指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
" 秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键；如要修改"<leader>"键，可以把
" 下面的设置取消注释，并修改双引号中的键为你想要的，如修改为逗号键。

let mapleader = ","
