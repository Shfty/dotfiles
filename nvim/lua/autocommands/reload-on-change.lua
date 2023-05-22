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
    callback = function()
        vim.cmd.echohl("WarningMsg")
        vim.cmd("echo 'File changed on disk. Buffer reloaded.'")
        vim.cmd.echohl("None")
    end
})
