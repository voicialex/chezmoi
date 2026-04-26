#!/usr/bin/env bash

_help_desc "terminal" "系统" "终端输入编辑与通用快捷键"

help-terminal() {
  cat <<'EOF'
── Terminal Line Editing ────────────────────────────────────
  说明:
    下面这些多半是终端行编辑能力，不是 Codex / Claude Code 私有命令
    所以在 bash、很多 REPL、Codex 终端版、Claude Code 终端版里通常通用
    但如果某个程序自己接管按键，个别快捷键可能失效或行为不同

  光标移动:
    Ctrl+A                移到行首
    Ctrl+E                移到行尾
    Alt+B                 按单词向左跳
    Alt+F                 按单词向右跳

  删除输入:
    Ctrl+U                删除光标左侧整段内容
    Ctrl+K                删除光标右侧整段内容
    Ctrl+W                删除左侧一个单词
    Ctrl+Backspace        常见为删除左侧一个单词，但依赖终端映射
    Alt+D                 删除右侧一个单词，部分终端可能不一致

  历史与恢复:
    Ctrl+R                反向搜索历史输入
    Ctrl+Y                粘贴刚刚删除的内容
    Ctrl+L                清屏，但不清当前输入

  最常用组合:
    Ctrl+U                快速清空当前行
    Ctrl+W                逐词回删
    Ctrl+A 然后 Ctrl+K    保留左侧，删掉整段尾部
    Ctrl+R                搜以前问过的话或执行过的命令

  在图形输入框中:
    Ctrl+A, Backspace     全选后删除，通常最稳妥

  和 AI 工具命令的区别:
    Ctrl+A / Ctrl+U / Ctrl+R 这类是终端输入编辑，通常跨工具通用
    /help /model /approvals   这类是应用命令，只在具体工具里生效

  判断规则:
    如果是在"发送前编辑这一行"，大概率是终端通用能力
    如果是在"控制会话、切模型、看权限"，那通常是工具私有命令
─────────────────────────────────────────────────────────────
EOF
}
