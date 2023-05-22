-- Auto-fold i3config files with repeated hash quotes
local function i3_folding()
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
