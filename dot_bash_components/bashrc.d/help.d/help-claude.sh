#!/usr/bin/env bash

_help_desc "claude" "AI工具" "Claude Code 常用命令"

help-claude() {
  cat <<'EOF'
── Claude Code ──────────────────────────────────────────────
  安装（npm）:
    npm install -g @anthropic-ai/claude-code

  启动（跳过权限确认）:
    claude --dangerously-skip-permissions

  恢复/保存/重命名会话:
    claude --dangerously-skip-permissions -c
    /resume <session-name>
    /save   <session-name>
    /rename <session-name>
    /context 查询当前会话上下文信息

  Claudeline 状态栏更新:
    rm -f ~/.claude/claudeline && chezmoi apply

  Agent Teams 模式（在 settings.json 中启用，无需额外参数）:
    teammateMode: auto     自动分窗格（tmux/iTerm2）或 in-process
    teammateMode: tmux     强制 tmux 分窗格
    teammateMode: in-process  当前进程内运行
─────────────────────────────────────────────────────────────
EOF
}
