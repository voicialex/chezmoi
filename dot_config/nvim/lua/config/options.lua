-- Neovim 选项（LazyVim 默认选项基础上追加）
-- LazyVim 默认选项: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.relativenumber = true    -- 相对行号，配合 j/k 快速跳转
vim.opt.scrolloff = 8            -- 光标上下保留 8 行，滚动时不会贴边
vim.opt.sidescrolloff = 8        -- 水平方向同理
vim.opt.wrap = false             -- 长行不换行，用左右滚动
vim.opt.clipboard = "unnamedplus" -- 系统剪贴板同步（需要 xclip/wl-clipboard）
vim.opt.undolevels = 10000       -- 撤销历史
vim.opt.ignorecase = true        -- 搜索忽略大小写
vim.opt.smartcase = true         -- 但搜索含大写字母时区分大小写
vim.opt.signcolumn = "yes"       -- 始终显示左侧符号列，防止文本抖动
vim.opt.updatetime = 250         -- 250ms 无操作就触发 swap 写入和 CursorHold
vim.opt.timeoutlen = 300         -- 按键序列等待时间（ms），太长会觉得卡
vim.opt.autoread = true          -- 外部修改文件时自动重载

-- 切回 nvim 时刷新文件（配合 Claude Code 等外部编辑）
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })
