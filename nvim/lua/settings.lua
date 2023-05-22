HOME = os.getenv("HOME")

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
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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
vim.opt.bufhidden = "delete"

-- Don't use swap files
vim.opt.swapfile = false

-- Cache undo history across vim sessions
vim.opt.undofile = true

-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 300

-- Always show the sign column (prevents diagnostic pop-in)
vim.opt.signcolumn = "yes"

-- Don't automatically insert or select from completion popup, and show regardless of match count
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Set macro wildchar key to tab
vim.opt.wildcharm = ('\t'):byte()

-- Use the OS clipboard as the unnamed register
vim.opt.clipboard = "unnamedplus"

-- Use 1:1 mouse scrolling
vim.opt.mousescroll = "ver:1,hor:1"

-- Update terminal window title on buffer change
vim.opt.title = true

-- Set leader to backspace
vim.g.mapleader = vim.api.nvim_replace_termcodes('<BS>', true, true, true)

-- Prevent Ctrl+Z under windows
if vim.loop.os_uname().sysname == 'Windows' then
    vim.keymap.set('n', '<C-z>', '<Nop>', { remap = true })
end
