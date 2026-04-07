#!/bin/sh
# 检测系统剪贴板工具，未安装时打印提示

# WSL 自带 clip.exe，无需额外安装
command -v clip.exe >/dev/null 2>&1 && exit 0

# 检测 Wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
  if ! command -v wl-copy >/dev/null 2>&1; then
    echo "⚠  未检测到 wl-copy，tmux 鼠标复制无法写入系统剪贴板"
    echo "   安装命令: sudo apt install wl-clipboard"
  fi
  exit 0
fi

# 检测 X11
if [ -n "$DISPLAY" ]; then
  if ! command -v xclip >/dev/null 2>&1; then
    echo "⚠  未检测到 xclip，tmux 鼠标复制无法写入系统剪贴板"
    echo "   安装命令: sudo apt install xclip"
  fi
  exit 0
fi
