vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- scroll half page and center cursor in buffer
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- swap lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Reselect after indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Navigating findings windows (what is it called again) and (what's l?)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- yank into system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete without yanking
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set("n", "x", [["_x"]])

-- Search
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "#", "#zz")

-- Manage tabs
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", {desc = "new tab"})
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", {desc = "close tab"})
vim.keymap.set("n", "<leader>tl", "<cmd>tabn<CR>", {desc = "next tab"})
vim.keymap.set("n", "<leader>th", "<cmd>tabp<CR>", {desc = "previous tab"})

-- Formatting
vim.keymap.set("n", "<leader>q", "<cmd>%!jq .<CR>")

-- Neovim development
vim.keymap.set("n", "<leader>m", "<cmd>messages<CR>")

-- greatest remap ever (according to primeagen - no idea what this does)
vim.keymap.set("x", "<leader>p", [["_dP]])
