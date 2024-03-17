return {
    {
        "ThePrimeagen/vim-be-good"
    },
    {
        "tpope/vim-commentary"
    },
    {
        "kylechui/nvim-surround"
    },
    {
        "kdheepak/lazygit.nvim",
        keys = {
            {
                ";c",
                ":LazyGit<CR>",
                silent = true,
                noremap = true,
            }
        }
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require('fidget').setup({})
        end
    },
}
