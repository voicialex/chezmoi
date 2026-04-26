#!/usr/bin/env bash

_help_desc "codex" "AI工具" "Codex 常用命令"

help-codex() {
  cat <<'EOF'
── Codex ───────────────────────────────────────────────────
  安装（npm）:
    npm install -g @openai/codex

  启动:
    codex

  查看帮助:
    codex --help
    codex exec --help
    codex login --help

  登录状态:
    codex login status

  半自动模式（低打断，仍在沙箱内）:
    codex exec --full-auto "你的任务"
    等价于:
    codex exec -a on-request --sandbox workspace-write "你的任务"

  全权限危险模式（跳过审批+关闭沙箱）:
    codex exec --dangerously-bypass-approvals-and-sandbox "你的任务"

  单次执行:
    codex exec "帮我检查当前仓库里最近的改动"

  跳过 Git 仓库检查执行:
    codex exec --skip-git-repo-check "输出当前目录说明"

  指定沙箱模式:
    codex exec --sandbox read-only "只读分析这个项目"
    codex exec --sandbox workspace-write "修复一个小问题并直接改代码"

  JSON 输出:
    codex exec --json "Reply with OK only."

  常用速记:
    codex                  进入交互模式
    /help                  查看会话内命令
    /model                 查看或切换模型
    /approvals             查看权限策略

  终端输入编辑:
    help-terminal         查看 Ctrl+A / Ctrl+U / Ctrl+R 等通用输入技巧

  典型用法:
    codex
    codex exec --full-auto "帮我修一个小问题并直接修改代码"
    codex exec --dangerously-bypass-approvals-and-sandbox "直接处理当前仓库中的问题"
    codex exec --sandbox read-only "分析 perception_app 的模块结构"
    codex exec --sandbox workspace-write "为 build.sh 增加一个 --help 说明"
─────────────────────────────────────────────────────────────
EOF
}
