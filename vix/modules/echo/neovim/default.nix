{ lib, pkgs, config, vix, USER, ... }: {
  home-manager.users.${USER} = {

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withRuby = true;
      withPython3 = true;

      extraConfig = ''
      set nocompatible
      filetype off
      filetype plugin indent on
      set ttyfast
      set ttymouse=xterm2
      set ttyscroll=3

      set laststatus=2
      set encoding=utf-8              " Set default encoding to UTF-8
      set autoread                    " Automatically reread changed files without asking me anything
      set autoindent
      set backspace=indent,eol,start  " Makes backspace key more powerful.
      set incsearch                   " Shows the match while typing
      set hlsearch                    " Highlight found searches
      set mouse=a                     " Enable mouse mode

      set noerrorbells             " No beeps
      set number                   " Show line numbers
      set showcmd                  " Show me what I'm typing
      set noswapfile               " Don't use swapfile
      set nobackup                 " Don't create annoying backup files
      set splitright               " Split vertical windows right to the current windows
      set splitbelow               " Split horizontal windows below to the current windows
      set autowrite                " Automatically save before :next, :make etc.
      set hidden
      set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
      set noshowmatch              " Do not show matching brackets by flickering
      set noshowmode               " We show the mode with airline or lightline
      set ignorecase               " Search case insensitive...
      set smartcase                " ... but not it begins with upper case
      set completeopt=menu,menuone
      set nocursorcolumn           " speed up syntax highlighting
      " set nocursorline
      set cursorline
      set updatetime=300
      set pumheight=10             " Completion window max size
      set conceallevel=2           " Concealed text is completely hidden

      set shortmess+=c   " Shut off completion messages
      set belloff+=ctrlg " If Vim beeps during completion

      set lazyredraw

      "http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
      set clipboard^=unnamed
      set clipboard^=unnamedplus

      " increase max memory to show syntax highlighting for large files
      set maxmempattern=20000

      " ~/.viminfo needs to be writable and readable. Set oldfiles to 1000 last
      " recently opened files, :FzfHistory uses it
      set viminfo='1000

      if has('persistent_undo')
        set undofile
        set undodir=~/.cache/vim
      endif

      " color
      let g:nord_cursor_line_number_background = 1
      let g:nord_italic = 1
      let g:nord_italic_comments = 1
      let g:nord_bold = 1
      let g:nord_bold_vertical_split_line = 1
      let g:nord_uniform_status_lines = 1
      let g:nord_underline = 1
      colorscheme nord
      set termguicolors

      augroup filetypedetect
        command! -nargs=* -complete=help Help vertical belowright help <args>
        autocmd FileType help wincmd L

        autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
        autocmd BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
        autocmd BufNewFile,BufRead *.hcl setf conf

        autocmd BufRead,BufNewFile *.gotmpl set filetype=gotexttmpl

        autocmd BufNewFile,BufRead *.ino setlocal noet ts=4 sw=4 sts=4
        autocmd BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
        autocmd BufNewFile,BufRead *.md setlocal noet ts=4 sw=4
        autocmd BufNewFile,BufRead *.html setlocal noet ts=4 sw=4
        autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2 tabstop=2
        autocmd BufNewFile,BufRead *.hcl setlocal expandtab shiftwidth=2 tabstop=2
        autocmd BufNewFile,BufRead *.sh setlocal expandtab shiftwidth=2 tabstop=2
        autocmd BufNewFile,BufRead *.proto setlocal expandtab shiftwidth=2 tabstop=2
        autocmd BufNewFile,BufRead *.fish setlocal expandtab shiftwidth=2 tabstop=2

        autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
        autocmd FileType rust setlocal noexpandtab tabstop=4 shiftwidth=4
        autocmd FileType solidity setlocal expandtab tabstop=4 shiftwidth=4
        autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2

        autocmd FileType sh setlocal expandtab shiftwidth=2 tabstop=2
        autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
        autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
        autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
        autocmd FileType typescript setlocal expandtab shiftwidth=2 tabstop=2
      augroup END

      "=====================================================
      "===================== STATUSLINE ====================

      let g:tmuxline_preset = {
            \'a'    : '#S',
            \'win'  : '#I #W',
            \'cwin' : '#I #W',
            \'x'    : '%a',
            \'y'    : '%Y-%m-%d %H:%M',
            \'z'    : '  #h',
            \'options' : {'status-justify' : 'left', 'status-position' : 'top'}}

      let g:tmuxline_powerline_separators = 0

      "=====================================================
      "===================== MAPPINGS ======================

      " yiw, move, viw,p, move again, viw,p, etc
      xnoremap <leader>p "_dP

      " This comes first, because we have mappings that depend on leader
      " With a map leader it's possible to do extra key combinations
      " i.e: <leader>w saves the current file
      let mapleader = ","

      " Some useful quickfix shortcuts for quickfix
      map <C-n> :cn<CR>
      map <C-m> :cp<CR>
      nnoremap <leader>a :cclose<CR>

      " put quickfix window always to the bottom
      augroup quickfix
          autocmd!
          autocmd FileType qf wincmd J
          autocmd FileType qf setlocal wrap
      augroup END

      " Enter automatically into the files directory
      autocmd BufEnter * silent! lcd %:p:h

      " Automatically resize screens to be equally the same
      autocmd VimResized * wincmd =

      " Fast saving
      nnoremap <leader>w :w!<cr>
      nnoremap <silent> <leader>q :q!<CR>

      " Center the screen
      nnoremap <space> zz

      " Remove search highlight
      " nnoremap <leader><space> :nohlsearch<CR>
      function! s:clear_highlight()
        let @/ = ""
        call go#guru#ClearSameIds()
      endfunction
      nnoremap <silent> <leader><space> :<C-u>call <SID>clear_highlight()<CR>

      " echo the number under the cursor as binary, useful for bitwise operations
      function! s:echoBinary()
        echo printf("%08b", expand('<cword>'))
      endfunction
      nnoremap <silent> gb :<C-u>call <SID>echoBinary()<CR>

      " Source the current Vim file
      nnoremap <leader>pr :Runtime<CR>

      " Close all but the current one
      nnoremap <leader>o :only<CR>

      " Better split switching
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l

      " Print full path
      map <C-f> :echo expand("%:p")<cr>

      " Mnemonic: Copy File path
      nnor <leader>cf :let @*=expand("%:p")<CR>

      " Terminal settings
      if has('terminal')
        " Kill job and close terminal window
        tnoremap <Leader>q <C-w><C-C><C-w>c<cr>

        " switch to normal mode with esc
        tnoremap <Esc> <C-W>N

        " mappings to move out from terminal to other views
        tnoremap <C-h> <C-w>h
        tnoremap <C-j> <C-w>j
        tnoremap <C-k> <C-w>k
        tnoremap <C-l> <C-w>l

        " Open terminal in vertical, horizontal and new tab
        nnoremap <leader>tv :vsplit<cr>:term ++curwin<CR>
        nnoremap <leader>ts :split<cr>:term ++curwin<CR>
        nnoremap <leader>tt :tabnew<cr>:term ++curwin<CR>

        tnoremap <leader>tv <C-w>:vsplit<cr>:term ++curwin<CR>
        tnoremap <leader>ts <C-w>:split<cr>:term ++curwin<CR>
        tnoremap <leader>tt <C-w>:tabnew<cr>:term ++curwin<CR>

        " always start terminal in insert mode when I switch to it
        " NOTE(arslan): startinsert doesn't work in Terminal-normal mode.
        " autocmd WinEnter * if &buftype == 'terminal' | call feedkeys("i") | endif
      endif

      " Visual linewise up and down by default (and use gj gk to go quicker)
      noremap <Up> gk
      noremap <Down> gj
      noremap j gj
      noremap k gk

      " Exit on jj and jk
      imap jk <Esc>
      imap jj <Esc>

      " Source (reload configuration)
      nnoremap <silent> <F5> :source $NVIMRC<CR>

      nnoremap <F6> :setlocal spell! spell?<CR>

      " Search mappings: These will make it so that going to the next one in a
      " search will center on the line it's found in.
      nnoremap n nzzzv
      nnoremap N Nzzzv

      " Same when moving up and down
      noremap <C-d> <C-d>zz
      noremap <C-u> <C-u>zz

      " Remap H and L (top, bottom of screen to left and right end of line)
      nnoremap H ^
      nnoremap L $
      vnoremap H ^
      vnoremap L g_

      " Act like D and C
      nnoremap Y y$

      " Do not show stupid q: window
      map q: :q

      " Don't move on * I'd use a function for this but Vim clobbers the last search
      " when you're in a function so fuck it, practicality beats purity.
      nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

      " mimic the behavior of /%Vfoobar which searches within the previously
      " selected visual selection
      " while in search mode, pressing / will do this
      vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
      vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

      " Time out on key codes but not mappings.
      " Basically this makes terminal Vim work sanely.
      if !has('gui_running')
        set notimeout
        set ttimeout
        set ttimeoutlen=10
        augroup FastEscape
          autocmd!
          au InsertEnter * set timeoutlen=0
          au InsertLeave * set timeoutlen=1000
        augroup END
      endif

      " Visual Mode */# from Scrooloose {{{
      function! s:VSetSearch()
        let temp = @@
        norm! gvy
        let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
        let @@ = temp
      endfunction

      vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
      vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

      " create a go doc comment based on the word under the cursor
      function! s:create_go_doc_comment()
        norm "zyiw
        execute ":put! z"
        execute ":norm I// \<Esc>$"
      endfunction
      nnoremap <leader>ui :<C-u>call <SID>create_go_doc_comment()<CR>


      "===================== PLUGINS ======================

      " ==================== open-browser ====================

      " default netrw is not working anymore, switch to a custom plugin
      " (open-browser.vim)  https://github.com/vim/vim/issues/4738
      let g:netrw_nogx = 1 " disable netrw's gx mapping.
      nmap gx <Plug>(openbrowser-smart-search)
      vmap gx <Plug>(openbrowser-smart-search)

      " ==================== Fugitive ====================
      vnoremap <leader>gb :Gblame<CR>
      nnoremap <leader>gb :Gblame<CR>

      " ==================== vim-go ====================
      let g:go_fmt_fail_silently = 1
      let g:go_debug_windows = {
            \ 'vars':  'leftabove 35vnew',
            \ 'stack': 'botright 10new',
      \ }

      let g:go_test_show_name = 1
      let g:go_list_type = "quickfix"

      let g:go_autodetect_gopath = 1
      let g:go_metalinter_autosave_enabled = ['vet', 'golint']
      let g:go_metalinter_enabled = ['vet', 'golint']

      let g:go_gopls_complete_unimported = 1

      " 2 is for errors and warnings
      let g:go_diagnostics_level = 2
      let g:go_doc_popup_window = 1

      let g:go_imports_mode="gopls"
      let g:go_imports_autosave=1

      let g:go_highlight_build_constraints = 1
      let g:go_highlight_operators = 1

      let g:go_fold_enable = []

      nmap <C-g> :GoDecls<cr>
      imap <C-g> <esc>:<C-u>GoDecls<cr>


      " run :GoBuild or :GoTestCompile based on the go file
      function! s:build_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
          call go#test#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
          call go#cmd#Build(0)
        endif
      endfunction

      augroup go
        autocmd!

        autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
        autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
        autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def)
        autocmd FileType go nmap <silent> <Leader>e <Plug>(go-referrers))

        autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc)

        autocmd FileType go nmap <silent> <Leader>i <Plug>(go-info)
        autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)

        autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<CR>
        autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
        autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
        autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

        autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)

        " I like these more!
        autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
        autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
        autocmd Filetype go command! -bang Q call go#lsp#Exit()
      augroup END


      " ==================== FZF ====================
      let g:fzf_command_prefix = 'Fzf'
      let g:fzf_layout = { 'down': '~20%' }

      " search
      nmap <C-p> :FzfGFiles<cr>
      imap <C-p> <esc>:<C-u>FzfGFiles<cr>

      " search across files in the current directory
      nmap <C-b> :FzfFiles<cr>
      imap <C-b> <esc>:<C-u>FzfFiles<cr>

      " Command for git grep
      " - fzf#vim#grep(command, with_column, [options], [fullscreen])
      command! -bang -nargs=* FF
        \ call fzf#vim#grep(
        \   'git grep --line-number --color=always --column --ignore-case -- '.shellescape(<q-args>), 1,
        \   {'dir': systemlist('git rev-parse --show-toplevel')[0]}, <bang>0)

      let g:rg_command = '
        \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
        \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf,rs,sol}"
        \ -g "!{.git,node_modules,vendor,env,venv}/*" '

      command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)

      command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

      " ==================== delimitMate ====================
      let g:delimitMate_expand_cr = 1
      let g:delimitMate_expand_space = 1
      let g:delimitMate_smart_quotes = 1
      let g:delimitMate_expand_inside_quotes = 0
      let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'
      let g:delimitMate_quotes = "\" '"

      imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

      " ==================== NerdTree ====================
      " For toggling
      noremap <Leader>n :NERDTreeToggle<cr>
      noremap <Leader>f :NERDTreeFind<cr>

      let NERDTreeShowHidden=1

      " ==================== ag ====================
      let g:ackprg = 'ag --vimgrep --smart-case'
      let g:ag_working_path_mode="r"
      let $FZF_DEFAULT_COMMAND = 'ag -g ""'

      " ==================== markdown ====================
      let g:vim_markdown_folding_disabled = 1
      let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh', 'racket=lisp']
      let g:vim_markdown_conceal = 2
      " let g:vim_markdown_conceal_code_blocks = 0
      let g:vim_markdown_toml_frontmatter = 1
      let g:vim_markdown_frontmatter = 1
      let g:vim_markdown_new_list_item_indent = 2
      let g:vim_markdown_no_extensions_in_markdown = 1
      let g:vim_markdown_math = 1

      " create a hugo front matter in toml format to the beginning of a file. Open
      " empty markdown file, i.e: '2018-02-05-speed-up-vim.markdown'. Calling this
      " function will generate the following front matter under the cursor:
      "
      "   +++
      "   author = "echo"
      "   date = 2018-02-03 08:41:20
      "   title = "Speed up vim"
      "   slug = "speed-up-vim"
      "   url = "/2018/02/03/speed-up-vim/"
      "   featured_image = ""
      "   description =  ""
      "   +++
      "
      function! s:create_front_matter()
        let fm = ["+++"]
        call add(fm, 'author = "echo"')
        call add(fm, printf("date = \"%s\"", strftime("%Y-%m-%d %X")))

        let filename = expand("%:r")
        let tl = split(filename, "-")
        " in case the file is in form of foo.md instead of
        " year-month-day-foo.markdown
        if !empty(str2nr(tl[0]))
          let tl = split(filename, "-")[3:]
        endif

        let title = join(tl, " ")
        let title = toupper(title[0]) . title[1:]
        call add(fm, printf("title = \"%s\"", title))

        let slug = join(tl, "-")
        call add(fm, printf("slug = \"%s\"", slug))
        call add(fm, printf("url = \"%s/%s/\"", strftime("%Y/%m/%d"), slug))

        call add(fm, 'featured_image = ""')
        call add(fm, 'description = ""')
        call add(fm, "+++")
        call append(0, fm)
      endfunction

      " create a shortcode that inserts an image holder with caption or class
      " attribute that defines on how to set the layout.
      function! s:create_figure()
        let fig = ["{{< figure"]
        call add(fig, 'src="/images/image.jpg"')
        call add(fig, 'class="left"')
        call add(fig, 'caption="This looks good!"')
        call add(fig, ">}}")

        let res = [join(fig, " ")]
        call append(line("."), res)
      endfunction

      augroup md
        autocmd!
        autocmd Filetype markdown command! -bang HugoFrontMatter call <SID>create_front_matter()
        autocmd Filetype markdown command! -bang HugoFig call <SID>create_figure()
      augroup END

      " ==================== vim-json ====================
      let g:vim_json_syntax_conceal = 0

      " ==================== Completion + Snippet ====================
      " Ultisnips has native support for SuperTab. SuperTab does omnicompletion by
      " pressing tab. I like this better than autocompletion, but it's still fast.
      let g:SuperTabDefaultCompletionType = "context"
      let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
      let g:UltiSnipsExpandTrigger="<tab>"
      let g:UltiSnipsJumpForwardTrigger="<tab>"
      let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

      " ==================== Various other plugin settings ====================
      nmap  -  <Plug>(choosewin)

      " Trigger a highlight in the appropriate direction when pressing these keys:
      let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

      " python
      " vim-python
      augroup vimrc-python
        autocmd!
        autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=79
            \ formatoptions+=croq softtabstop=4
            \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
      augroup END

      " jedi-vim
      let g:jedi#popup_on_dot = 0
      let g:jedi#goto_assignments_command = "<leader>g"
      let g:jedi#goto_definitions_command = "<leader>d"
      let g:jedi#documentation_command = "K"
      let g:jedi#usages_command = "<leader>u"
      let g:jedi#rename_command = "<leader>r"
      let g:jedi#show_call_signatures = "0"
      let g:jedi#smart_auto_mappings = 0
      let g:jedi#completions_enabled = 0
      let g:jedi#auto_vim_configuration = 0

      let g:python_host_prog = '/usr/bin/python'
      let g:python3_host_prog = '/usr/local/bin/python3'

      " vim-autopep8
      let g:autopep8_on_save = 1
      let g:autopep8_disable_show_diff=1

      " supertab

      " let g:SuperTabDefaultCompletionType = "<c-n>"
      let g:SuperTabContextDefaultCompletionType = "<c-n>"

      " vim-racer
      augroup Racer
        autocmd!
        autocmd FileType rust nmap <buffer> <leader>d  <Plug>(rust-def)
        autocmd FileType rust nmap <buffer> <leader>s  <Plug>(rust-def-split)
        autocmd FileType rust nmap <buffer> <leader>v  <Plug>(rust-def-vertical)
        autocmd FileType rust nmap <buffer> <leader>x  <Plug>(rust-doc)
        autocmd FileType rust nmap <buffer> <leader>X  <Plug>(rust-doc-tab)
        autocmd FileType rust nmap <buffer> <leader>r  :Crun<cr>
        autocmd FileType rust nmap <buffer> <leader>t  :RustTest<cr>
        autocmd FileType rust nmap <buffer> <leader>T  :RustTest!<cr>
        autocmd FileType rust nmap <buffer> <leader>b  :Cbuild<cr>
      augroup END

      let g:racer_experimental_completer = 1
      let g:racer_insert_paren = 1

      " deoplete.nvim
      let g:deoplete#enable_at_startup = 1

      " editorconfig/editorconfig-vim
      let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

      " vim-prettier
      " let g:prettier#autoformat = 0
      " autocmd BufWritePre *.sol Prettier

      " rust-lang/rust
      let g:rustfmt_autosave = 1

      highlight ExtraWhitespace ctermbg=LightRed guibg=LightRed
      autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t\+\|\t\+\zs \+/

      " vim: sw=2 sw=2 et
      '';
    };
  };
}
