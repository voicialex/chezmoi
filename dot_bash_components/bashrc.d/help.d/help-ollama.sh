#!/usr/bin/env bash

_help_desc "ollama" "AI工具" "Ollama 本地 LLM 管理"

help-ollama() {
  cat <<'EOF'
── Ollama ──────────────────────────────────────────────────
  安装:
    curl -fsSL https://ollama.com/install.sh | sh

  使用顺序（安装后按此步骤操作）:
    1) 设置模型存储路径（pull 之前设置，否则模型会下载到默认位置）
       export OLLAMA_MODELS=/home/seb/buddy_ws/ollama/models
       mkdir -p $OLLAMA_MODELS

    2) nohup 启动服务（关闭终端不会停止）
       OLLAMA_MODELS=$OLLAMA_MODELS nohup ollama serve > /tmp/ollama.log 2>&1 &

    3) 下载模型
       ollama pull gemma4:e2b

    4) 运行模型
       ollama run gemma4:e2b "你好"

  停止服务:
    pkill -f "ollama serve"

  查看状态:
    pgrep -f "ollama serve" && echo "运行中" || echo "已停止"

  模型管理:
    ollama list                   列出已下载的模型
    ollama rm <模型名>            删除模型

  常用模型:
    gemma4:e2b                    Google Gemma 4
    llama3                        Meta Llama 3
    mistral                       Mistral 7B
    codellama                     Code Llama（代码专用）

  参考:
    ~/chezmoi/docs/ollama-install.md  安装文档
─────────────────────────────────────────────────────────────
EOF
}
