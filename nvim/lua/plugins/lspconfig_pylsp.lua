require 'lspconfig'.pylsp.setup {
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

