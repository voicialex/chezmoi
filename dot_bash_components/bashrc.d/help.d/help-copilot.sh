#!/usr/bin/env bash

_help_desc "copilot" "AI工具" "copilot-api 启动/停止"

help-copilot() {
  cat <<'EOF'
── copilot-api 代理 ─────────────────────────────────────────
  安装 Node.js 最新版（Ubuntu）:
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs

  安装（npm）:
    npm install -g copilot-api

  注：copilot-api 需要 Bun 运行时，首次 start 会自动安装。
    如需手动安装 Bun: curl -fsSL https://bun.sh/install | bash

  后台启动（默认端口 4141）:
    nohup copilot-api start &> ~/.local/share/copilot-api/server.log &

  后台启动（自定义端口）:
    nohup copilot-api start --port 8080 &> ~/.local/share/copilot-api/server.log &

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

── Claude Code 对接 ────────────────────────────────────────
  在 ~/.claude/settings.json 的 env 里设置:
    "ANTHROPIC_BASE_URL": "http://localhost:4141"
  端口必须和 copilot-api start --port 一致。
  注: GLM 和 copilot-api 后端互斥，同一时间只能用一个 ANTHROPIC_BASE_URL。

  /etc/hosts 需要添加（屏蔽直连 Anthropic）:
    127.0.0.1 api.anthropic.com
    127.0.0.1 statsig.anthropic.com
  chezmoi apply 会自动检查并提示缺失的条目。

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
