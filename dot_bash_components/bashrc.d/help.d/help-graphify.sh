#!/usr/bin/env bash

_help_desc "graphify" "开发" "Graphify 代码图谱工具"

help-graphify() {
  cat <<'EOF'
── Graphify ─────────────────────────────────────────────────
  [安装]
    pip install graphifyy                    包名 graphifyy，命令 graphify

  [注册到 AI 助手]（建图后执行一次）
    graphify claude install                  Claude Code（支持 hook）
    graphify codex install                   Codex（支持 hook）
    graphify copilot install                 GitHub Copilot CLI
    卸载: graphify <platform> uninstall

  [过滤文件] 项目根目录创建 .graphifyignore（.gitignore 语法）
    node_modules/                            排除目录
    *.generated.py                           排除匹配文件
    *                                        排除所有，配合 ! 反选：
    !src/                                      只索引 src/ 目录
    !src/**

  [构建 & 更新]
    /graphify                                首次建图（在 AI 助手内）
    graphify update .                        增量更新（终端，无需 LLM）
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
