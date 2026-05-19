#!/usr/bin/env bash

_help_desc "graphify" "开发" "Graphify 代码图谱工具"

help-graphify() {
  cat <<'EOF'
── Graphify ──────────────────────────── ⬡ = 在 AI 助手内 ──
  [安装]
    pip install graphifyy                    包名 graphifyy，命令 graphify

  [注册到 AI 助手]（首次建图前执行一次）
    graphify install                         自动检测已装平台，一次全部注册
    graphify claude install                  仅 Claude Code
    graphify codex install                   仅 Codex
    graphify copilot install                 仅 GitHub Copilot CLI
    卸载: graphify <platform> uninstall

  [Codex 首次安装（含 $graphify 技能）]
    graphify install                         先确保 Claude 技能已就位
    graphify codex install                   写入项目 AGENTS.md + 注册 hook
    cp -rf ~/.claude/skills/graphify ~/.codex/skills/
                                             同步技能文件到 Codex

  [过滤文件] 项目根目录创建 .graphifyignore（.gitignore 语法）
    node_modules/                            排除目录
    *.generated.py                           排除匹配文件
    *                                        排除所有，配合 ! 反选：
    !src/                                      只索引 src/ 目录
    !src/**

  [构建 & 更新]
    /graphify                          ⬡    首次建图（需 LLM）→ graphify-out/
    graphify extract .                       首次建图（终端，需 LLM API key）
    graphify update .                        增量更新（纯 AST，无需 LLM）
    graphify update . --force                强制全量重建

  [查询 & 分析]
    graphify query "<问题>"                  BFS 遍历图谱
    graphify query "<问题>" --dfs --budget 3000
    graphify path "A" "B"                    最短路径
    graphify explain "NodeName"              节点及邻居

  [自动化]
    graphify hook install/uninstall/status   Git 钩子（自动增量更新）
    graphify watch .                         监听文件变更
    graphify cluster-only .                  仅重新聚类
─────────────────────────────────────────────────────────────
EOF
}
