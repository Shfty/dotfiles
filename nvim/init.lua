HOME = os.getenv("HOME")

---- Autocommands

-- Auto-fold vim files using repeated double-quotes to define nesting depth
function vim_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldlevel= 0
    vim.opt_local.foldexpr = "getline(v:lnum)=~'^\"\"'?'>'.(matchend(getline(v:lnum),'\"\"*')-1):'='"
end

vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "vim",
        callback = vim_folding
    }
)

-- Auto-fold i3config files with repeated hash quotes
function i3_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldlevel = 0
    vim.opt_local.foldexpr = "getline(v:lnum)=~'^##'?'>'.(matchend(getline(v:lnum),'##*')-1):'='"
end

vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "i3config",
        callback = i3_folding
    }
)

-- Transparent background override
function bg_transparent()
    vim.cmd.highlight({ "Normal", "guibg=none" })
    vim.cmd.highlight({ "NonText", "guibg=none" })
end

function bg_neovide()
    vim.cmd.highlight({ "Normal", "guibg=#282A36" })
    vim.g.neovide_transparency = 0.8
    vim.opt.guifont="FiraCode_Nerd_Font:h12:#e-antialias:#h-full"
end

if vim.g.neovide == nil then
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = bg_transparent
    })
else
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = bg_neovide
    })
end

local cargo_toml_crates = vim.api.nvim_create_augroup('cargo_toml_crates', { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "Cargo.toml",
    group = cargo_toml_crates,
    command = [[call crates#toggle()]]
})


-- Checklist highlights
function set_checklist_highlight()
    vim.cmd.highlight("Tick", "ctermfg=lightgreen guifg=lightgreen")
    vim.cmd.highlight("Cross", "ctermfg=red guifg=red")
    vim.cmd.highlight("Arrow", "ctermfg=yellow guifg=yellow")
    vim.cmd.highlight("Unchecked", "ctermfg=lightgray guifg=lightgray")
    
    vim.cmd([[call matchadd("Arrow", "\\[>\\]")]])
    vim.cmd([[call matchadd("Tick", "\\[✓\\]")]])
    vim.cmd([[call matchadd("Cross", "\\[✗\\]")]])
    vim.cmd([[call matchadd("Unchecked", "\\[ \\]")]])
end

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = set_checklist_highlight
})

--- Automatic reload-on-change

-- Trigger checktime when files changes on disk
-- Manual implementation of autoread setting,
-- minus the caveat of needing to run an external command
-- before reloading occurs
vim.api.nvim_create_autocmd(
    {
            "FocusGained",
            "BufEnter",
            "CursorHold",
            "CursorHoldI"
    },
    {
            pattern = "*",
            callback = function()
                local re = vim.regex('\v(c|r.?|!|t)')
                if not re:match_str(vim.api.nvim_get_mode().mode) and vim.fn.getcmdwintype() == '' then
                    vim.cmd.checktime()
                end
            end
    }
)

--- Notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",
    callback = [[
        echohl WarningMsg
        echo "File changed on disk. Buffer reloaded."
        echohl None
    ]]
})

--- Rust-specific LSP bindings
function rust_bindings()
    vim.keymap.set('n', '<Leader>[', '<cmd>RustHoverActions<CR>')
    vim.keymap.set('n', '<Leader>.', '<cmd>RustCodeAction<CR>')
    vim.keymap.set('n', '<Leader>k', '<cmd>RustMoveItemUp<CR>')
    vim.keymap.set('n', '<Leader>j', '<cmd>RustMoveItemDown<CR>')
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = rust_bindings,
})


---- Settings

-- Backspace over the column where insert mode starts, and over auto-indents
vim.opt.backspace = { 'start', 'indent', 'eol' }

-- Copy current indent when creating a new line
vim.opt.autoindent = true

-- Don't wrap text
vim.opt.wrap = false

-- Create backup files
vim.opt.backup = true

-- Write backup files
vim.opt.writebackup = true

-- Custom backup directory
vim.opt.backupdir = HOME .. "/.local/state/nvim/backup/"

-- 50 lines of command history
vim.opt.history = 50

-- Show command on last line
vim.opt.showcmd = true

-- Highlight current search result
vim.opt.incsearch = true

-- Don't show filename in the statusline
vim.opt.laststatus = 0

-- Idiomatic configuration for 4-wide tabs
vim.opt.tabstop=8
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab = true

-- Enable hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable RGB color 
vim.opt.termguicolors = true

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Don't highlight search results
vim.opt.hlsearch = false

-- Don't allow switching away from a buffer with outstanding changes
vim.opt.hidden = false

-- Delete buffers that are no longer displayed in a window
vim.opt.bufhidden = delete

-- Don't use swap files
vim.opt.swapfile = false

-- Cache undo history across vim sessions
vim.opt.undofile = true

-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 300

-- Always show the sign column (prevents diagnostic pop-in)
vim.opt.signcolumn = "yes"

-- Don't automatically insert or select from completion popup, and show regardless of match count
vim.opt.completeopt = { menuone, noinsert, noselect }

-- Set macro wildchar key to tab 
vim.opt.wildcharm = ('\t'):byte()

-- Use the OS clipboard as the unnamed register
vim.opt.clipboard = unnamedplus

-- Use 1:1 mouse scrolling
vim.opt.mousescroll = "ver:1,hor:1"

-- Update terminal window title on buffer change
vim.opt.title = true

---- Plugins

--- Dracula
local dracula = require 'dracula'
local colors = dracula.colors()

dracula.setup({
    show_end_of_buffer = true,
    transparent_bg = true,
    lualine_bg_color = colors.selection,
    italic_comment = true,
})

vim.cmd[[colorscheme dracula]]

--- rust.vim
-- Enable folding
vim.g.rust_fold = true

--- netrw
vim.g.netrw_banner = false
vim.g.netrw_fastbrowse = false
vim.g.netrw_browse_split = false
vim.g.netrw_liststyle = 3

--- tagbar
vim.g.tagbar_autofocus = true
vim.g.tagbar_autoclose = true

--- nvim-compe
vim.g.compe = {}
vim.g.compe.enabled = true
vim.g.compe.source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
}
vim.g.compe.documentation = true

--- nvim-tree
require "nvim-tree".setup{
    view = {
        width = 40,
    },
    diagnostics = {
        enable = true,
    },
}

--- Lualine
require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'dracula-nvim',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {},
  inactive_sections = {},
  tabline = {},
  winbar = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress', 'searchcount', 'selectioncount'},
    lualine_z = {'location'}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {
    'fugitive',
    'nvim-dap-ui',
    'nvim-tree',
  }
}

--- rust-tools
require 'rust-tools'.setup{
    server = {
        cmd_env = {
            CARGO_TARGET_DIR = "/tmp/rust-analyzer-check"
        }
    },
    dap = {
        adapter = {
            type = "executable",
            command = "/usr/bin/lldb-vscode",
            name = "rt_lldb",
        }
    }
}

--- gdscript
-- require'lspconfig'.gdscript.setup{}

--- jsonls
require 'lspconfig'.jsonls.setup{}

--- pylsp
require 'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        black = {
          enabled = true,
        },
        pycodestyle = {
          maxLineLength = 88,
        }
      }
    }
  }
}

--- HTML
require 'lspconfig'.html.setup{}

--- nvim-treesitter
require 'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

--- nvim-dap
local dap = require('dap')

dap.set_log_level('TRACE')

dap.adapters.cppdbg = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/home/josh/.local/src/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},
  }
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    env = { CARGO_MANIFEST_DIR = "${workspaceFolder}" },
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require("dap.ext.vscode").load_launchjs(nil, { cppdbg = {"c", "cpp", "rust"}})

--- nvim-dap-ui
local dapui = require("dapui")

local opts = {
  layouts = {
    {
      elements = {
        { id = "watches", size = 0.25 },
        { id = "scopes", size = 0.75 },
      },
      size = 0.25,
      position = "bottom",
    },
    {
      elements = {
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.75 },
      },
      size = 0.25,
      position = "bottom",
    },
    {
      elements = {
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
}

dapui.setup(opts)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

---- Remaps

--- Core

-- Map esc to leave terminal insert mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n')

-- Map \s to reload vimrc
vim.keymap.set('n', '<Leader>s', ':source $MYVIMRC<CR>')

-- Map \v to edit .vimrc
vim.keymap.set('n', '<Leader>v', ':e $MYVIMRC<CR>')

-- Map \[0-9] to quick buffer switching
vim.keymap.set('n', '<Leader>1', ':1b<CR>')
vim.keymap.set('n', '<Leader>2', ':2b<CR>')
vim.keymap.set('n', '<Leader>3', ':3b<CR>')
vim.keymap.set('n', '<Leader>4', ':4b<CR>')
vim.keymap.set('n', '<Leader>5', ':5b<CR>')
vim.keymap.set('n', '<Leader>6', ':6b<CR>')
vim.keymap.set('n', '<Leader>7', ':7b<CR>')
vim.keymap.set('n', '<Leader>8', ':8b<CR>')
vim.keymap.set('n', '<Leader>9', ':9b<CR>')
vim.keymap.set('n', '<Leader>0', ':10b<CR>')

-- Map gb to interactive buffer switching
vim.keymap.set('n', '<Leader>gb', ':b <C-i>')

-- \k to show quickfix list
vim.keymap.set('n', '<Leader>k', ':cwindow<CR>')

-- \l to show location list
vim.keymap.set('n', '<Leader>l', ':lwindow<CR>')

--- IDE

-- Navigation
vim.keymap.set('n', '<F1>', '<Nop>')
vim.keymap.set('n', '<F2>', '<Nop>')
vim.keymap.set('n', '<F3>', ':TagbarToggle<CR>')
vim.keymap.set('n', '<F4>', ':NvimTreeFindFileToggle<CR>')
vim.keymap.set('n', '<F5>', ':NvimTreeFocus<CR>')

-- LSP
vim.keymap.set('n', '<Leader>[', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', '<Leader>]', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', '<Leader>}', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
vim.keymap.set('n', '<Leader>cw', '<cmd>lua vim.lsp.buf.rename()<CR><C-l>')
vim.keymap.set('n', '<Leader>.', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<Leader>/', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', '<Leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

-- Goto previous/next diagnostic warning/error
vim.keymap.set('n', '<Leader>g[', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<Leader>g]', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>gg', function()
    vim.diagnostic.open_float(nil, { source = 'always' })
end)

qflist_diagnostics = function()
   local diagnostics = vim.diagnostic.get()
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
    vim.diagnostic.setqflist(qflist)
end

vim.keymap.set('n', '<Leader>gl', function()
    qflist_diagnostics()
    vim.cmd('botright copen')
end)

-- DAP
vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<Leader>r', dap.repl.open)
vim.keymap.set('n', '<F9>', dap.continue)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_into)

-- Prevent Ctrl+Z under windows
if vim.loop.os_uname().sysname == 'Windows' then
    vim.keymap.set('n', '<C-z>', '<Nop>', { remap = true })
end
