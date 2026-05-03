#!/usr/bin/env bash

_help_desc "nvim" "编辑器" "Neovim (LazyVim) 使用"

help-nvim() {
  cat <<'EOF'
── Neovim (LazyVim) ────────────────────────────────────────
  安装位置:
    /opt/nvim/bin/nvim           可执行文件
    ~/.config/nvim               配置目录（LazyVim）

  首次启动:
    nvim                         直接运行，LazyVim 会自动安装所有插件
                                 等待右下角提示消失（约 1-2 分钟）
                                 安装完成后按 q 关闭面板，再按 :q 退出
    第二次打开就不会再安装了

  打开项目后的第一步:
    1. Space e                   打开左侧文件树，浏览项目结构
    2. 用 j/k 上下移动选择文件
    3. 按 Enter 打开文件
    4. Space Space                全局搜索文件名，快速跳转
    5. Space /                    全局搜索文件内容

  折叠（Fold）:
    za                           切换当前折叠（打开↔关闭）
    zc                           关闭当前折叠
    zo                           打开当前折叠
    zM                           关闭所有折叠
    zR                           打开所有折叠

  插件管理:
    :Mason                       管理语言 Server（LSP/格式化/调试）
                                 搜索 → i 安装 → X 卸载
    :Lazy                        總理插件（更新/清理）

  文件与搜索 (前缀 Space):
    Space e                      文件树（neo-tree）
    Space Space                  全局搜索文件名
    Space /                      全局搜索文件内容
    Space f r                    最近打开的文件

  代码导航:
    gd                           跳到定义（go definition）
    gr                           查看引用（go references）
    K                            查看悬停文档
    Ctrl+o                       跳回上一个位置
    Ctrl+i                       跳到下一个位置

  编辑:
    gcc                          注释/取消注释当前行
    gc（可视模式）                注释/取消注释选中区域

  窗口操作:
    Ctrl+h/j/k/l                 在窗格间移动
    Ctrl+w v                     垂直分屏
    Ctrl+w s                     水平分屏
    Ctrl+w q                     关闭当前窗格

  终端（LazyVim 默认 Snacks）:
    Ctrl+/                       切换当前唯一浮动终端（单例）
    数字 + Ctrl+/                1<C-/> / 2<C-/> 打开或切换编号终端
    Ctrl+\ Ctrl+n                从终端模式回到普通模式
    i                              在终端窗口中进入终端输入模式

  文件比较（Diff）:
    nvim -d file1 file2          终端启动，垂直分屏对比两个文件
    :vert diffsplit file2        在 nvim 内对比当前文件和 file2
    ]c                           跳到下一个差异处
    [c                           跳到上一个差异处
    dp                           把当前差异推到另一边（diff put）
    do                           从另一边拉取差异到当前（diff obtain）
    :diffupdate                  手动刷新差异

  Git Diff（比较当前文件改动）:
    Space g h d                  对比当前文件 vs 暂存区（垂直分屏）
    Space g h D                  对比当前文件 vs 上一次 commit（HEAD~1）
    Space g h p                  浮动窗口预览当前改动块（按 q 关闭）
    ]h                           跳到下一个改动块
    [h                           跳到上一个改动块
    Space g f                    查看当前文件所有 commit 历史（选中预览 diff）

  关闭比较窗口:
    :q                           关闭当前分屏窗格（光标在哪个窗格就关哪个）
    Ctrl+w q                     同上，关闭当前窗格

  文件切换（最常用）:
    Ctrl+^                       当前文件 ↔ 上一个文件（两个文件来回横跳）
    ]b                           下一个 buffer（多文件前进）
    [b                           上一个 buffer（多文件后退）

  参考:
    ~/chezmoi/docs/nvim-setup.md 安装文档
    ~/.config/nvim               配置目录（chezmoi 管理自定义文件）
─────────────────────────────────────────────────────────────
EOF
}
