#!/usr/bin/env bash
# 加载用户本地配置（别名、环境变量等）
# 位于 bashrc.d/ 最后加载（z_ 前缀保证字母排序末尾）

# 统一加载用户自定义 aliases
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# 本机/工作区配置（与系统 bashrc 隔离）
if [ -f "$HOME/.bash_local" ]; then
  . "$HOME/.bash_local"
fi
