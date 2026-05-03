#!/usr/bin/env bash

_help_desc "graphify" "开发" "Graphify 代码图谱工具"

help-graphify() {
  cat <<'EOF'
── Graphify ─────────────────────────────────────────────────
  [安装]
    pip install graphifyy                    安装（包名 graphifyy，命令 graphify）
    graphify install                         注册 Claude Code skill

  [首次构建] （在 Claude Code 内执行）
    /graphify                                LLM 语义抽取 + AST 解析，生成完整图谱

  [增量更新] （终端执行）
    graphify update .                        仅重新解析变更文件（无需 LLM，速度快）
    graphify update . --force                强制覆盖（重构删代码后节点变少时）

  [查询]
    graphify query "<问题>"                  BFS 遍历图谱回答问题
    graphify query "<问题>" --dfs --budget 3000
                                              深度优先 + 限制输出 token 数

  [分析]
    graphify path "A" "B"                    查两个节点间最短路径
    graphify explain "NodeName"              解释某节点及其邻居

  [Git Hook 自动重建]
    graphify hook install                    安装 post-commit/checkout 钩子（自动增量更新）
    graphify hook uninstall                  卸载钩子
    graphify hook status                     查看钩子状态

  [监听 & 聚类]
    graphify watch .                         监听文件变更，自动重建图谱
    graphify cluster-only .                  重新聚类（不重新解析，只刷新报告）

  [典型流程]
    1. /graphify                             首次在 Claude Code 中建图
    2. graphify query "入口在哪"             终端查询
    3. graphify update .                     代码改动后增量更新
─────────────────────────────────────────────────────────────
EOF
}
