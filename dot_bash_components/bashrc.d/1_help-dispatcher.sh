#!/usr/bin/env bash
# 帮助系统调度器 — 加载 help/ 子目录下的主题文件，各文件通过 _help_desc 注册

_HELP_REGISTRY=""

_help_desc() {
  _HELP_REGISTRY="${_HELP_REGISTRY}${1}|${2}|${3}"$'\n'
}

# 加载 help.d/ 子目录下的主题文件
_help_dir="$(dirname "${BASH_SOURCE[0]}")/help.d"
if [ -d "$_help_dir" ]; then
  for _hf in "$_help_dir"/*.sh; do
    [ -r "$_hf" ] && . "$_hf"
  done
  unset _hf
fi
unset _help_dir

help() {
  # 有参数时回退到 bash 内建 help（如 help cd）
  if [ $# -gt 0 ]; then
    builtin help "$@"
    return
  fi
  echo "可用帮助主题："
  [ -z "$_HELP_REGISTRY" ] || printf '%s' "$_HELP_REGISTRY" | sort -t'|' -k2,2 -k1,1 | awk -F'|' '
    NF < 3 { next }
    $2 != prev {
      if (prev != "") print ""
      printf "  [%s]\n", $2
      prev = $2
    }
    { printf "    help-%-15s %s\n", $1, $3 }
  '
}
