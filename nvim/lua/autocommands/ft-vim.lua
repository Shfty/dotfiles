-- Auto-fold vim files using repeated double-quotes to define nesting depth
local function vim_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldlevel = 0
    vim.opt_local.foldexpr = "getline(v:lnum)=~'^\"\"'?'>'.(matchend(getline(v:lnum),'\"\"*')-1):'='"
end

vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "vim",
        callback = vim_folding
    }
)
