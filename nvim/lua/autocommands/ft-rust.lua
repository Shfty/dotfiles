--- Rust-specific LSP bindings
local function rust_bindings()
    vim.keymap.set('n', '<Leader>i', '<cmd>RustHoverActions<CR>')
    vim.keymap.set('n', '<Leader>.', '<cmd>RustCodeAction<CR>')
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = rust_bindings,
})
