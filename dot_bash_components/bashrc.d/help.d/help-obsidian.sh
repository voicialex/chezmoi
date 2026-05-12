#!/usr/bin/env bash

_help_desc "obsidian" "知识库" "Obsidian Vault 常用操作"

help-obsidian() {
  cat <<'EOF'
── Obsidian Vault ────────────────────────────────────────────
  [部署]
    git clone git@github.com:voicialex/obsidian_vault.git ~/obsidian_vault
                                               克隆 vault 到固定路径
    chezmoi apply                              应用 symlink（Claude/Codex 规则）

  [同步]
    cd ~/obsidian_vault && git pull            拉取最新
    git add -A && git commit -m "笔记: 描述"   提交修改
    git push                                   推送到 GitHub

  [项目接入（opt-in）]
    mkdir ~/obsidian_vault/10_Projects/<name>  接入项目（Claude/Codex 自动识别）
    rm -rf ~/obsidian_vault/10_Projects/<name> 断开项目

  [目录结构]
    raw/              原始资料（不可变）
    00_Inbox/         待整理
    10_Projects/      项目文档
    20_Learning/      学习笔记
    30_Resources/     资料收藏
    40_Journal/       日志（Claude 只读）
    50_Claude/        Claude/Codex 记忆与规则
    90_Templates/     模板
    99_Attachments/   附件

  [LLM Wiki 操作]
    Ingest: 丢原始资料进 raw/，Claude 提取知识更新 wiki
    Query:  对知识库提问，Claude 先读 index.md 再综合回答
    Lint:   定期检查矛盾、孤立页面、缺失链接

  [验证]
    ls -la ~/.claude/rules/obsidian.md         检查 Claude 规则 symlink
    ls -la ~/.codex/instructions/obsidian.md   检查 Codex 规则 symlink
─────────────────────────────────────────────────────────────
EOF
}
