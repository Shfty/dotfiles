local function set_checklist_highlight()
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
