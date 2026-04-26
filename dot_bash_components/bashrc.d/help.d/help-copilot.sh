#!/usr/bin/env bash

_help_desc "copilot" "AI工具" "copilot-api 启动/停止"

help-copilot() {
  cat <<'EOF'
── copilot-api 代理 ─────────────────────────────────────────
  后台启动:
    nohup copilot-api start &> ~/.local/share/copilot-api/server.log &

  停止:
    pkill -f "copilot-api start"

  查看日志:
    tail -f ~/.local/share/copilot-api/server.log

  验证运行:
    ss -tulpn | grep 4141
    curl http://localhost:4141/v1/models

  重新认证:
    copilot-api auth
  查询使用情况:
    npx copilot-api check-usage

── Copilot CLI ──────────────────────────────────────────────
  启动（允许所有工具）:
    copilot --allow-all-tools

  启动（禁用指定工具，如禁止 git push）:
    copilot --deny-tool='shell(git push)'

  多条规则叠加:
    copilot --allow-all-tools --deny-tool='shell(git push)' \
            --deny-tool='shell(rm -rf)'
─────────────────────────────────────────────────────────────
EOF
}
