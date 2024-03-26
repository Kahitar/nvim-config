function FindVueFileReferences()
    local bufnr = vim.api.nvim_get_current_buf()
    local uri = vim.uri_from_bufnr(bufnr)

    -- Check if the current buffer is a Vue.js file
    local filetype = vim.bo.filetype
    if filetype ~= 'vue' then
        vim.notify("This command can only be used in Vue.js files.", vim.log.levels.WARN)
        return
    end

    print("Finding references for " .. uri .. "[" .. bufnr .. "]")

    vim.lsp.buf_request(bufnr, 'volar/client/findFileReference', { textDocument = { uri = uri } }, function(err, result, ctx, config)
        if err then
            -- print("ERR:", vim.inspect(err))
            -- vim.notify("Error finding references: " .. vim.inspect(err), vim.log.levels.ERROR)
        else
            -- Convert the result to quickfix items
            local items = {}
            for _, ref in ipairs(result) do
                print(vim.inspect(ref))
                table.insert(items, {
                    filename = vim.uri_to_fname(ref.uri),
                    lnum = ref.range.start.line + 1,
                    col = ref.range.start.character + 1,
                    text = 'Reference'
                })
            end
            -- Populate the quickfix
            vim.fn.setqflist(items)
            -- Open the quickfix telescope window
            vim.cmd('Telescope quickfix')
            print("Loaded " .. #items .. " references into quickfix list.")
        end
    end)
end

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
                    --  This is not true anymore for volar > v2.x -> see comment below to upgrade it
                    -- "tsserver",
                    -- If you want to update to v2.x, remember that tsserver (or similar?) and a plugin for 
                    -- that is needed. See https://github.com/vuejs/language-tools/issues/3925
                    "volar@1.8.0", -- vue 3 language server
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
                volar = {
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
            -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
            vim.keymap.set('n', 'N', vim.lsp.buf.rename, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>cf', vim.diagnostic.open_float, {})
            vim.keymap.set('n', 'fr', '<cmd>lua FindVueFileReferences()<CR>', { noremap = true, silent = true })
        end
    },
}
