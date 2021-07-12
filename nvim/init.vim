"" Autocommands
""" Auto-fold vim files using repeated double-quotes to define nesting depth
function VimFolding()
    setlocal foldmethod=expr foldlevel=0
    setlocal foldexpr=getline(v:lnum)=~'^\"\"'?'>'.(matchend(getline(v:lnum),'\"\"*')-1):'='
endfunction
autocmd FileType vim call VimFolding()

""" Transparent background override
function TransparentBackground()
    highlight Normal guibg=none
    highlight NonText guibg=none
endfunction

autocmd ColorScheme * call TransparentBackground()

""" LSP events
augroup lsp_events
    " Show diagnostic popup on cursor hold
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })

    " Enable type inlay hints
    autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
    \ lua require'lsp_extensions'.inlay_hints {
        \   prefix = '',
        \   highlight = "Comment",
        \   enabled = {"TypeHint", "ChainingHint", "ParameterHint"}
        \   }
augroup END

""" Checklist highlights

function SetChecklistHighlight()
    highlight Tick ctermfg=lightgreen guifg=lightgreen
    highlight Cross ctermfg=red guifg=red
    highlight Arrow ctermfg=yellow guifg=yellow
    highlight Unchecked ctermfg=lightgray guifg=lightgray
    
    call matchadd("Arrow", "\\[>\\]")
    call matchadd("Tick", "\\[✓\\]")
    call matchadd("Cross", "\\[✗\\]")
    call matchadd("Unchecked", "\\[ \\]")
endfunction

autocmd BufWinEnter * call SetChecklistHighlight()

"" Settings

" Backspace over the column where insert mode starts, and over auto-indents
set backspace=start,indent

" Copy current indent when creating a new line
set autoindent

" Don't create a backup file
set nobackup

" 50 lines of command history
set history=50

" Show command on last line
set showcmd

" Highlight current search result
set incsearch

" Don't show the mode in the statusline (handled by lightline)
set noshowmode

" Don't show ruler in the statusline (handled by lightline)
set noruler

" Idiomatic configuration for 4-wide tabs
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" Enable hybrid line numbers
set number
set relativenumber

" Enable RGB color 
set termguicolors

" Don't highlight search results
set nohlsearch

" Allow buffers to exist without a window
set hidden

" Cache undo history across vim sessions
set undofile

" 300ms of no cursor movement to trigger CursorHold
set updatetime=300

" Always show the sign column (prevents diagnostic pop-in)
set signcolumn=yes

" Don't automatically insert or select from completion popup, and show regardless of match count
set completeopt=menuone,noinsert,noselect

" Set macro wildchar key to tab 
set wildcharm=<Tab>

"" Remaps
""" Core

" Map esc to leave terminal insert mode
tnoremap <Esc> <C-\><C-n>

" Map \s to reload .vimrc
nnoremap <Leader>s :source $MYVIMRC<CR>

" Map \v to edit .vimrc
nnoremap <Leader>v :e $MYVIMRC<CR>

" Map \[0-9] to quick buffer switching
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" Map gb to interactive buffer switching
nnoremap <Leader>gb :b <C-i>

" \k to show quickfix list
nnoremap <Leader>k :cwindow<CR>

" \l to show location list
nnoremap <Leader>l :lwindow<CR>

""" IDE

" Navigation
nnoremap <F1> <Nop>
nnoremap <F2> <Nop>
nnoremap <F3> :TagbarToggle<CR>
nnoremap <F4> :Lexplore<CR>

" Cargo functions
nnoremap <F5> :wa<CR>:Cargo build<CR>
nnoremap <F6> :wa<CR>:Cargo run<CR>
nnoremap <F7> :wa<CR>:Cargo install --path .<CR>

" LSP
nnoremap <Leader>[  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <Leader>]  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <Leader>}  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <Leader>cw <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>.  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <Leader>/  <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <Leader>f  <cmd>lua vim.lsp.buf.formatting()<CR>

" Goto previous/next diagnostic warning/error
nnoremap  <Leader>g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap  <Leader>g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" DAP
nnoremap <Leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <Leader>r :lua require'dap'.repl.open()<CR>
nnoremap <F9> :lua require'dap'.continue()<CR>
nnoremap <F10> :lua require'dap'.step_over()<CR>
nnoremap <F11> :lua require'dap'.step_into()<CR>
nnoremap <F12> :lua require'dap'.step_into()<CR>

"" Plugins
""" netrw
let g:netrw_fastbrowse=0
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

""" tagbar
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

""" Dracula
" Color scheme
packadd! dracula
colorscheme dracula

""" Lightline
" Customization
let g:lightline = {
    \ 'colorscheme': 'dracula',
    \ 'active': {
    \   'left': [
    \       [ 'mode', 'paste', 'readonly'],
    \       [ 'buffers' ],
    \   ],
    \   'right': [
    \       [ 'lineinfo' ],
    \       [ 'percent' ],
    \       [ 'gitbranch', 'fileformat', 'fileencoding', 'filetype' ],
    \   ]
    \ },
    \ 'inactive': {
    \   'left': [
    \       [ 'filename' ],
    \   ],
    \   'right': [
    \       [ 'lineinfo' ],
    \       [ 'percent' ]
    \   ]
    \ },
    \ 'separator': {
    \   'left': '',
    \   'right': '',
    \ },
    \ 'subseparator': {
    \   'left': '',
    \   'right': '',
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers'
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel'
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ }
    \ }

" Show internal buffer indices
let g:lightline#bufferline#show_number = 1

""" rust.vim
" Enable folding
let g:rust_fold = 1

""" nvim-compe
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.source = {
\ 'path': v:true,
\ 'buffer': v:true,
\ 'nvim_lsp': v:true,
\ }
let g:compe.documentation = v:true

""" rust_analyzer
lua <<EOF
require'lspconfig'.rust_analyzer.setup({
    cmd_env = {
        CARGO_TARGET_DIR = "/tmp/rust-analyzer-check"
    }
})
EOF

""" gdscript
"lua require'lspconfig'.gdscript.setup{}

""" LSP

lua <<EOF
-- Custom handler to populate quickfix list when diagnostics are published
diagnostic_handler = function(err, method, result, client_id, bufnr, config)
   local diagnostics = vim.lsp.diagnostic.get_all()
    local qflist = {}
    for bufnr, diagnostic in pairs(diagnostics) do
      for _, d in ipairs(diagnostic) do
        d.bufnr = bufnr
        d.lnum = d.range.start.line + 1
        d.col = d.range.start.character + 1
        d.text = d.message
        table.insert(qflist, d)
      end
    end
    vim.lsp.util.set_qflist(qflist)

    return vim.lsp.diagnostic.on_publish_diagnostics(err, method, result, client_id, bufnr, config)
end

-- Configure diagnostics with virtual inlay text, column signs, and insert-mode updates
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    diagnostic_handler,
    {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    }
)
EOF

""" nvim-dap

lua <<EOF
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/bin/lldb-vscode-11',
  name = "lldb"
}

local dap = require('dap')
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}

dap.configurations.rust = dap.configurations.cpp
EOF

"" Other
""" Prevent Ctrl+Z under windows
let is_windows = has('win32') || has('win64')
if is_windows
    nmap <C-z> <Nop>
endif
