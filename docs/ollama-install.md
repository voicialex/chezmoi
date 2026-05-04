# Ollama 本地 LLM 安装指南

## 1. 安装 Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

## 2. 启动服务

```bash
# nohup 后台运行，断开终端不会停止
OLLAMA_MODELS=/home/seb/buddy_ws/ollama/models nohup ollama serve > /tmp/ollama.log 2>&1 &
```

## 3. 下载模型

```bash
OLLAMA_MODELS=/home/seb/buddy_ws/ollama/models ollama pull gemma4:e2b
```

## 4. 验证

```bash
ollama run gemma4:e2b "你好"
```
