--- Transparent background override

local function bg_transparent()
    vim.cmd.highlight({ "Normal", "guibg=none" })
    vim.cmd.highlight({ "NonText", "guibg=none" })
end

local function bg_neovide()
    vim.cmd.highlight({ "Normal", "guibg=#282A36" })
    vim.g.neovide_transparency = 0.8
    vim.opt.guifont = "FiraCode_Nerd_Font:h12:#e-antialias:#h-full"
end

local bg_callback
if vim.g.neovide then
    bg_callback = bg_neovide
else
    bg_callback = bg_transparent
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = bg_callback
})
