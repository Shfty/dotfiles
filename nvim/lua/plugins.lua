--- Dracula
local dracula = require 'dracula'
local colors = dracula.colors()

dracula.setup({
    show_end_of_buffer = true,
    transparent_bg = true,
    lualine_bg_color = colors.selection,
    italic_comment = true,
})

vim.cmd [[colorscheme dracula]]
vim.cmd.highlight({ "Visual", "gui=reverse" })
vim.cmd.highlight({ "CursorColumn", "NONE" })
vim.cmd.highlight({ "link", "CursorColumn", "CursorLine" })
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

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

--- nvim-tree
require "nvim-tree".setup {
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
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
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
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress', 'searchcount', 'selectioncount' },
        lualine_z = { 'location' }
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
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
require 'rust-tools'.setup {
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

require('plugins.lspconfig_jsonls')
require('plugins.lspconfig_lua_ls')
require('plugins.lspconfig_pylsp')
require('plugins.lspconfig_html')

--- nvim-treesitter
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    playground = {
        enable = true,
    },
}

--local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
--vim.keymap.set({ "n", "x", "o" }, "m", ts_repeat_move.repeat_last_move)
--vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

--- syntax-tree-surfer
local sts = require("syntax-tree-surfer")

local default_types = {
    "identifier",
    "field",
    "arguments",
    "call_expression",
    "let_declaration",
    "block",
    "function_item",
    "declaration_list",
    "mod_item",
    "source_file",
}

sts.setup({
    highlight_group = "STS_highlight",
    disable_no_instance_found_report = false,
    default_desired_types = default_types,
    left_hand_side = "fdsarweqvcxz",
    right_hand_side = "jklpuio;m,./",
    icon_dictionary = {
        ["arguments"] = "",
        ["call_expression"] = "󰊕",
        ["let_declaration"] = "󰫧",
        ["block"] = "󰅩",
        ["function_item"] = "󰊕",
        ["declaration_list"] = "",
        ["mod_item"] = "",
        ["source_file"] = "",
    },
})

vim.cmd.highlight({ "STS_highlight", "guifg=black guibg=white" })

-- Visual Selection from Normal Mode
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "vx", sts.select, opts)
vim.keymap.set("n", "vn", sts.select_current_node, opts)

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", function()
    sts.surf("next", "visual")
end, opts)
vim.keymap.set("x", "K", function()
    sts.surf("prev", "visual")
end, opts)
vim.keymap.set("x", "H", function()
    sts.surf("parent", "visual")
end, opts)
vim.keymap.set("x", "L", function()
    sts.surf("child", "visual")
end, opts)

-- Targeted Jump
--[[
vim.keymap.set( "n", "F", function()
    sts.targeted_jump({ "identifier", "type_identifier" })
end, opts)
]]

--- nvim-treezipper
local ntz = require('nvim-treezipper')
ntz.setup()

local zj = require('nvim-treezipper.zip-jump')
local zip_jump = function(query, query_group, backward, to_end, recurse)
    return function()
        zj.zip_jump(query, query_group, backward, to_end, recurse)
    end
end

vim.keymap.set("n", "<Space>s", zip_jump("@statement.outer", nil, false, false, true))
vim.keymap.set("n", "<Space>S", zip_jump("@statement.outer", nil, true, false, true))

vim.keymap.set("n", "<Space>f", zip_jump("@function.outer", nil, false, false, true))
vim.keymap.set("n", "<Space>F", zip_jump("@function.outer", nil, true, false, true))

vim.keymap.set("n", "<Space>b", zip_jump("@block.outer", nil, false, false, true))
vim.keymap.set("n", "<Space>B", zip_jump("@block.outer", nil, true, false, true))

vim.keymap.set("n", "<Space>c", zip_jump("@call.outer", nil, false, false, true))
vim.keymap.set("n", "<Space>C", zip_jump("@call.outer", nil, true, false, true))

vim.keymap.set("n", "<Space>a", zip_jump("@assignment.outer", nil, false, false, true))
vim.keymap.set("n", "<Space>A", zip_jump("@assignment.outer", nil, true, false, true))

vim.keymap.set("n", "<Space>r", zip_jump("@reference", "locals", false, false, true))
vim.keymap.set("n", "<Space>A", zip_jump("@reference", "locals", true, false, true))

--- nvim-dap
local dap = require('dap')

dap.set_log_level('TRACE')

dap.adapters.cppdbg = {
    type = 'server',
    port = "${port}",
    executable = {
        command = '/home/josh/.local/src/codelldb/extension/adapter/codelldb',
        args = { "--port", "${port}" },
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

require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp", "rust" } })

--- nvim-dap-ui
local dapui = require("dapui")

dapui.setup({
    layouts = {
        {
            elements = {
                { id = "watches", size = 0.25 },
                { id = "scopes",  size = 0.75 },
            },
            size = 0.25,
            position = "bottom",
        },
        {
            elements = {
                { id = "breakpoints", size = 0.25 },
                { id = "stacks",      size = 0.75 },
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
})

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
vim.keymap.set('n', '<Leader>i', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', '<Leader>o', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', '<Leader>cw', '<cmd>lua vim.lsp.buf.rename()<CR><C-l>')
vim.keymap.set('n', '<Leader>.', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<Leader>/', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', '<Leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

-- Goto previous/next diagnostic warning/error
vim.keymap.set('n', '<Leader>[', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<Leader>]', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>gg', function()
    vim.diagnostic.open_float(nil, { source = 'always' })
end)

local function qflist_diagnostics()
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
