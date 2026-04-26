#!/usr/bin/env bash
# 通用工具 PATH 配置（chezmoi 管理）
# 只添加实际存在的路径，不存在的自动跳过

_paths=(
  /opt/nvim/bin
  /usr/local/node/bin
  "$HOME/.bun/bin"
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "$HOME/.npm-global/bin"
)

for _p in "${_paths[@]}"; do
  [ -d "$_p" ] || continue
  case ":${PATH}:" in
    *":${_p}:"*) ;;
    *) export PATH="$_p:$PATH" ;;
  esac
done

unset _p _paths
