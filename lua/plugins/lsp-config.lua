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
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pylsp",
                    "gopls",
                    "kotlin_language_server",
                    -- Don't user together with volar, so volar takes over typescript,
                    --  see https://theosteiner.de/using-volars-takeover-mode-in-neovims-native-lsp-client
                    -- "tsserver", 
                    -- "volar", -- vue 3 language server
                    "vuels", -- vue 2 language server
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local default_capabilities = vim.lsp.protocol.make_client_capabilities()
            default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")

            local servers_config = {
                vuels = {
                    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
                },
                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                pycodestyle = {
                                    maxLineLength = 120
                                }
                            }
                        }
                    }
                },
            }

            mason_lspconfig.setup_handlers({
                function(server_name)
                    local server_config = servers_config[server_name] or {}
                    server_config.capabilities = default_capabilities
                    lspconfig[server_name].setup(server_config)
                end,
            })
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
            vim.keymap.set('n', 'N', vim.lsp.buf.rename, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
        end
    },
}
