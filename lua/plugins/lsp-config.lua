return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local mason_lsp = require("mason-lspconfig")
            mason_lsp.setup({
                ensure_installed = {
                    "lua_ls",
                    "pylsp",
                    "gopls",
                    "kotlin_language_server",
                    -- "tsserver", -- don't user together with volar, so volar takes over typescript
                    -- "vuels", -- vue 2 language server
                    "volar", -- vue 3 language server
                }
            })
            local lspconfig = require("lspconfig")
            mason_lsp.setup_handlers({
                function(server_name)
                    local server_config = {}
                    if server_name == 'volar' then
                        filetypes = { 'vue', 'typescript', 'javascript' }
                    end
                    lspconfig[server_name].setup(
                        server_config
                    )
                end,
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            local lspconfig = require("lspconfig")

            lspconfig.kotlin_language_server.setup({
                capabilities = capabilities
            })
            lspconfig.volar.setup({
                capabilities = capabilities,
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities
            })
            lspconfig.pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                maxLineLength = 120
                            }
                        }
                    }
                }
            })
            lspconfig.gopls.setup({
                capabilities = capabilities
            })

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
            vim.keymap.set('n', 'N', vim.lsp.buf.rename, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
        end
    },
}
