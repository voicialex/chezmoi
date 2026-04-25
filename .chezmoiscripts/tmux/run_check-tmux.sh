#!/bin/sh
# Check tmux availability after each chezmoi apply.

if ! command -v tmux >/dev/null 2>&1; then
  echo "[WARN] tmux not installed"
  echo "       Install: sudo apt install tmux"
fi
