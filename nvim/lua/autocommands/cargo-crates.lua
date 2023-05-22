local cargo_toml_crates = vim.api.nvim_create_augroup('cargo_toml_crates', { clear = true })

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "Cargo.toml",
    group = cargo_toml_crates,
    command = [[call crates#toggle()]]
})
