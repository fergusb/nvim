" neovim config file ~/.config/nvim/init.vim
" Fergus Bremner <fergus.bremner@gmail.com>

" Pathogen - must come first
execute pathogen#infect()
execute pathogen#helptags()

" Section: Settings {{{1
"---------------------------------------------------------------------------"

set autochdir               " Auto-change cwd to current file
set autowrite               " Auto write file when switching to another file or window
set cursorline
set enc=utf-8               " Default encoding to UTF-8
set fenc=utf-8              " ditto
set fileformat=unix         " Set fileformat to UNIX
set fileformats=unix,mac    " Fave filetypes
set lazyredraw              " Do not redraw, when running macros
set linebreak               " Don't break words on wrap
" set matchpairs+=<:>         " Bounce between matches
set noerrorbells            " Turn off error warnings
set nostartofline           " Keep the cursor in the current column with page commands
set novisualbell
set number                  " Show line numbers
set printfont=monospace:h9
set ruler                   " Always show current position
set scrolljump=2
set scrolloff=3             " show lines on vertcal scroll
set secure                  " Disable security risk features
set shell=zsh               " Set shell to zsh
set shortmess+=filmnrxoOtT  " abbr of messages (avoids 'hit enter'))"
" set showbreak=↪ 
set showtabline=1
set splitbelow              " New pane put below the current one
set splitright              " New pane put to the right of the current one
set switchbuf=usetab
set t_vb=                   " Disable error beeps
set shada=%,'20,<50,h       " Restore cursor position between sessions
" set shada+=n~/.config/nvim/shada/main.shada " Change location of shada file
" set whichwrap=b,s,h,l,<,>,[,] " keys wrap to previous/next line
set clipboard+=unnamedplus  " Always copy to system clipboard

" Section: Swap and backup {{{1
"---------------------------------------------------------------------------"

set undofile
set undolevels=100  " maximum number of changes that can be undone
set undoreload=100  " maximum number lines to save for undo on a buffer reload
set directory=$HOME/.config/nvim/tmp//,.,/tmp//  " swp files to /tmp if neccesary
set undodir=$HOME/.config/nvim/undo//
set viewdir=$HOME/.config/nvim/view//

" Section: Search {{{1
"---------------------------------------------------------------------------"

set magic                   " Magic on
" set mat=2
set nohls                   " Don't highlight search
set showmatch
set smartcase
" set wrapscan                " begin search at top when EOF reached

" Section: Syntax {{{1
"---------------------------------------------------------------------------"

syntax enable                " syntax highlighting
set synmaxcol=1024           " switch off for wide documents
set t_Co=256                 " force 256color
set modeline
set modelines=5
colorscheme acedia
if exists('$TMUX')
  " set term=screen-256color
endif

" Section: Status-line {{{1
"---------------------------------------------------------------------------"

" Format statusline
" set laststatus=2
set statusline=
set statusline+=%<[%n]\           " buffer number
set statusline+=%Y\ 
" set statusline+=[%{&encoding},    " encoding
" set statusline+=%{&fileformat}]   " file format
set statusline+=\ %F%m%r%h\        " filename and path
set statusline+=%w                 " flags
if &ft != 'mail'
  set statusline+=%{fugitive#statusline()} " git
endif
set statusline+=%=                 " right align
set statusline+=%P\ 
set statusline+=Ln:%l/%L\ 
set statusline+=Col:%c%V\ 

" Display the current mode and partially-typed commands in the status line
set showmode
set showcmd

" Section: Command line {{{1
"---------------------------------------------------------------------------"

set cmdheight=1
set su=.h,~,.o,.info,.swp,.obj,.pyc      " low priority filetypes

" Section: Formatting {{{1
"---------------------------------------------------------------------------"

filetype off
filetype plugin indent on

" set smartindent
set expandtab
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nowrap
set textwidth=79
" set formatoptions=qrn1
" set formatoptions=tcrqn2
" set wrapmargin=4
" set lbr
set equalprg=par\ -w79            " use par for =
" set formatprg=par\ -w80          " also use par for gq

" Section: Abbreviations {{{1
"---------------------------------------------------------------------------"

iabbr teh the
iabbr tehn then

" Section: Formats and filetypes {{{1
"---------------------------------------------------------------------------"
" autocommands
if has("autocmd")
  autocmd BufEnter * :syntax sync fromstart

  " use templates
  autocmd BufNewFile * silent! 0r ~/.config/nvim/skel/%:e.tpl

  " strip trailing white space
  autocmd FileType c,cpp,css,java,php,python,html,html.django autocmd BufWritePre <buffer> :%s/\s\+$//e

  " human dicts and speling
  " autocmd FileType mail,human,mkd,txt,vo_base set dict+=/usr/share/dict/words
  autocmd FileType mail,human,mkd,txt,vo_base set spelllang=en_gb,de

  " dynamically set filetype-specific dictionary
  " autocmd FileType * exec('setlocal dict+=~/.config/nvim/dict/'.expand('<amatch>').'.dict')

  augroup filetype
    autocmd BufRead,BufNewFile *.less set filetype=css
    autocmd BufRead,BufNewFile *.scss,*.less set fen foldmethod=indent
    autocmd BufRead,BufNewFile *.markdown,*.mdown,*.mkdn,*.md set filetype=mkd
  augroup END

  augroup css
    au!
    autocmd FileType css let css_fold=1
    autocmd FileType css set fen foldmethod=indent
    autocmd FileType css set ai et si ts=2 sw=2 sts=2
  augroup END

  " only show cursorline in current window
  augroup cursorline
    au!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END

  augroup mutt
    au!
    autocmd FileType mail set nonu noai nosi
    autocmd FileType mail set nobk noswapfile nowb
    autocmd FileType mail set tw=80 fo=wantq1 smc=0
  augroup END

  augroup text
    au!
    autocmd FileType txt set js
    autocmd FileType txt set nosi
    autocmd FileType txt set tw=80 fo+=aw2tq
  augroup END

  augroup markdown
    au!
    autocmd FileType mkd set nonu nosi nofen ts=4 sts=4 sw=4
    autocmd FileType mkd set ai tw=80 fo+=wantq1 comments=n:>
    " autocmd FileType mkd set ai tw=80 fo+=aw2tq comments=n:>
  augroup END

  " in human-language files, automatically format everything at 80 chars:
  autocmd FileType vo_base,human set nonu ts=4 sts=4 sw=4 tw=80 fo+=aw2tq

  " for C-like programming, have automatic indentation:
  autocmd FileType c,cpp,slang set cindent

  " for actual C (not C++) programming where comments have explicit end
  " characters, if starting a new line in the middle of a comment automatically
  " insert the comment leader characters:
  autocmd FileType c set fo+=ro

  augroup Python
    au!
    autocmd FileType python setlocal nowrap
    autocmd FileType python,python.django setlocal foldlevel=99
  augroup END

  augroup xml
    au!
    au syntax xml setlocal equalprg=xmlindent\ -i\ 2\ -l\ 78
  augroup END

  " Perl, PHP indentation
  autocmd FileType perl,php set ai et sr

  " JSP and JSTL indentation
  autocmd FileType jsp set ai et

  " format html but leave long lines alone
  autocmd FileType html,xhtml,xml,xsl set nofen foldmethod=indent fo+=tl
  autocmd FileType xml,xslt setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235
else
  set ai ts=2 sts=2 sw=2 " defaults for everything else
endif " end has("autocmd")

" Section: Autocompletion {{{1
"---------------------------------------------------------------------------"
" initialize omnicompletion

" completion style
" set wildmenu
set wildmode=list:longest
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.bak,.DS_Store,*.pyc
" set complete=.,w,b,u,t
set completeopt=longest,menuone
" set complete=.,k,w,b,u,t,]
" set complete=.,k,w,b,u,t,i,]
" set completeopt=menu,longest,preview
set infercase

autocmd FileType c setlocal omnifunc=ccomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Section: Keymapping {{{1
"---------------------------------------------------------------------------"
" set leader
let mapleader = ","
let g:mapleader = ","

" disable Ex Mode
nnoremap Q <Nop>

" new tab quick
nnoremap <leader>t :tabnew<cr>

" edit this file
nnoremap <leader>ev :tabe $HOME/.config/nvimrc<cr>

"-- F-keys --"

" F2 toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" F3 list buffers and enter number to switch
nnoremap <F3> :buffers<CR>:buffer<Space>

" F4 wrap / no wrap
nnoremap <F4> :set invwrap wrap?<CR>

" CTRL+F8 to reformat file as XML
map <silent><C-F8> <Esc>:%!xmllint --format -<CR><CR>
vmap <silent><C-F8> <Esc>:'<, '>!xmllint --format -<CR><CR>

" backspace in Visual mode deletes selection
vnoremap <BS> d

" visual shifting (builtin-repeat)
" increase indent.
vnoremap <Tab> >gv
" decrease indent.
vnoremap <S-Tab> <gv

" standard control-backspace deletion
imap <C-BS> <C-W>

" make CTRL+] behave like CTRL+[ while in insert mode
imap <silent><C-]> <C-[>

" Reformat the current paragraph (or selected text if there is any)
nnoremap <leader>q gqap<CR>
vnoremap <leader>q gq<CR>

" lazy moving up and down
nnoremap j gj
nnoremap k gk

" Section: Brackets and auto-pairs {{{1
"---------------------------------------------------------------------------"

let g:loaded_matchparen = 1   " Turn off bracket matching grey

" Section: Date & time {{{1
"---------------------------------------------------------------------------"

" let g:timestamp_rep = '%Y-%m-%d'  " Format date thusly: YYYY-MM-DD
let g:timestamp_rep = '%Y-%m-%d %I:%M:%S %Z'  " Format date thusly: YYYY-MM-DD h:m:s Z
let g:timestamp_regexp = '\v\C%(<Last %([cC]hanged?|[Mm]odified):\s+)@<=.*$'

iab <silent> ddate <C-R>=strftime("%d %B %Y")<CR>
iab <silent> ttime <C-R>=strftime("%I:%M:%S %p %Z")<CR>
iab <silent> isoD <C-R>=strftime("%Y-%m-%d")<CR>

" Section: Plugin-dependent settings {{{1
"---------------------------------------------------------------------------"

" ack
" map <leader>aa :Ack<space>

" auto-pairs
let g:AutoPairsShortcutToggle = '<leader>pt'
let g:AutoPairsShortcutFastWrap = '<C-F>'
let g:AutoPairsShortcutJump = '<C-N>'
let g:AutoPairsShortcutBackInsert = '<C-B>'

" BufExplorer
map <silent><leader>b :BufExplorer<CR>

" gitgutter
set updatetime=250

" gundo
nnoremap <silent><leader>u :GundoToggle<CR>

" Disable AutoComplPop at startup
let g:acp_enableAtStartup = 0
autocmd WinEnter css :AcpEnable
autocmd WinLeave css :AcpDisable
" autocmd FileType mail,txt set :AcpDisable

" ShowMarks
let g:showmarks_enable = 0
let showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

" NERD commenter
let g:NERDMenuMode = 3
let g:NERDSpaceDelims = 1 " Adds space after comment 

" SuperTab
" let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabDefaultCompletionType = '<C-X><C-O>'
" let g:SuperTabDefaultCompletionType = '<C-X><C-U>'
let g:SuperTabRetainCompletionType=2
let g:SuperTabClosePreviewOnPopupClose = 1

if has("macunix")
  " let g:python_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python_host_prog = '/usr/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
  " disbale python interpreter checks
  let g:python_host_skip_check=1
  let g:python3_host_skip_check=1
endif
let g:deoplete#enable_at_startup=1

" python mode settings
" Keys:
" K             Show python docs
" <Tab>         Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

" Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 0
autocmd FileType python map <leader>l :PymodeLint<CR>

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
" let g:pymode_breakpoint_bind = '<leader>b'"
let g:pymode_lint_ignore="E501,W002" " ignore stuff

" Syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Enable python-mode rope or use Jedi (below) instead
let g:pymode_rope = 1

" Jedi goodness
" let g:jedi#completions_enabled = 1

" Yankring
nnoremap <silent><leader>y :YRShow<CR>
let g:yankring_history_dir = '$HOME/.config/nvim/tmp'
let g:yankring_replace_n_pkey = '<Nop>'
let g:yankring_replace_n_nkey = '<Nop>'

" Section: Experimental {{{1
"---------------------------------------------------------------------------"
"set grepprg to vimgrep function
set grepprg=vimgrep

" Section: Unsorted {{{1
"---------------------------------------------------------------------------"

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Remove pesky DOS/Windows ^M
noremap <leader>m0 mmHmt:%s/<C-V><CR>//ge<cr>'tzt'm

noremap % v% " visual to brace match 

" }}}

" vim:ft=vim:fdm=marker
