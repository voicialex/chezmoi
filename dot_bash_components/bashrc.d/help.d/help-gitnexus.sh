#!/usr/bin/env bash

_help_desc "gitnexus" "开发" "GitNexus 代码结构分析与影响面追踪"

help-gitnexus() {
  cat <<'EOF'
── GitNexus ─────────────────────────────────────────────────
  [安装] （需要 Node.js ≤22；Node 24+ 会导致依赖安装失败）
    npm install -g gitnexus                  全局安装（推荐）
    npx gitnexus analyze                     免安装，通过 npx 调用

  [首次配置] （在仓库根目录执行）
    gitnexus analyze                         建索引（自动生成 AGENTS.md/CLAUDE.md）
    gitnexus setup                           配置 MCP（一次性，自动检测编辑器）
    # 或手动：claude mcp add gitnexus -- npx -y gitnexus@latest mcp

  [索引管理]
    gitnexus analyze                         增量更新（仅重新解析变更文件）
    gitnexus analyze --force                 强制全量重建（重构后使用）
    gitnexus analyze --skip-embeddings       跳过 embedding（更快，适合大仓库）
    gitnexus status                          查看当前仓库索引状态
    gitnexus list                            列出所有已索引的仓库
    gitnexus clean                           删除当前仓库索引

  [文档生成]
    gitnexus wiki                            从知识图谱生成 wiki 文档

  [多仓聚合] （微服务/monorepo 场景）
    gitnexus group create <name>             创建仓库组
    gitnexus group add <group> <alias> <path> 添加子仓库
    gitnexus group sync <group>              同步组内所有仓库

  [日常使用]
    索引建好后，Claude Code 通过 MCP 自动查询图谱：
      context     获取符号的完整上下文（定义、调用者、被调用者）
      impact      分析修改某个文件/函数的影响面
      detect_changes  检测索引是否过期，提示重建

  [典型流程]
    1. gitnexus analyze                      在仓库根目录建索引
    2. gitnexus setup                        配置 MCP
    3. 正常用 Claude Code 编码               agent 自动调用图谱
    4. 大改后重跑 gitnexus analyze            增量更新
─────────────────────────────────────────────────────────────
EOF
}
