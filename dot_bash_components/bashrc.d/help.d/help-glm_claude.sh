#!/usr/bin/env bash

_help_desc "glm_claude" "AI工具" "GLM 接入 Claude Code"

help-glm_claude() {
  cat <<'EOF'
── GLM Claude ──────────────────────────────────────────────
  接入 GLM（智谱自动化助手）:
    npx @z_ai/coding-helper
    或:
    curl -O "https://cdn.bigmodel.cn/install/claude_code_env.sh" && bash ./claude_code_env.sh

  说明:
    用于将 GLM Coding Plan 接入 Claude Code
    按界面提示完成工具安装、套餐配置与 MCP 管理

  手动配置:
    编辑 `~/.claude/settings.json`:
    {
      "env": {
        "ANTHROPIC_AUTH_TOKEN": "your_zhipu_api_key",
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "API_TIMEOUT_MS": "3000000",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
      }
    }

    再编辑或新增 `~/.claude.json`:
    {
      "hasCompletedOnboarding": true
    }
─────────────────────────────────────────────────────────────
EOF
}
