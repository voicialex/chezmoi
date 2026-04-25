#!/bin/sh
# Check clipboard tool availability after each chezmoi apply.
# Only relevant when tmux is installed.

command -v tmux >/dev/null 2>&1 || exit 0
# WSL 自带 clip.exe，无需额外安装
command -v clip.exe >/dev/null 2>&1 && exit 0

# Wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
  if ! command -v wl-copy >/dev/null 2>&1; then
    echo "[WARN] wl-copy not found — tmux clipboard integration disabled"
    echo "       Install: sudo apt install wl-clipboard"
  fi
  exit 0
fi

# X11
if [ -n "$DISPLAY" ]; then
  if ! command -v xclip >/dev/null 2>&1; then
    echo "[WARN] xclip not found — tmux clipboard integration disabled"
    echo "       Install: sudo apt install xclip"
  fi
  exit 0
fi
