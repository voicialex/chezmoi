-- 自定义快捷键
-- LazyVim 默认快捷键: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- 在可视模式下用 J/K 移动选中行
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- 粘贴时不覆盖寄存器
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- 删除到黑洞寄存器（不污染剪贴板）
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

-- Ctrl+u/d 之后光标保持在中间
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })

-- 搜索时结果保持在中间
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- 全选
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- 当前文件与上一个文件互切（两个文件来回横跳）
vim.keymap.set("n", "<C-^>", "<cmd>b#<CR>", { desc = "Alternate file" })

-- 缓冲区前后切换（多文件切换）
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
