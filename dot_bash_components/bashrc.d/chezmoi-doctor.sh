#!/usr/bin/env bash
# 环境诊断工具：greeting 横幅 + chezmoi-doctor 检查命令
# 位于 bashrc.d/，由 bashrc.tmpl 自动加载

# 版本号（自动取最近 git 提交日期，无 git 时回退）
_CHEZMOI_VERSION="v$(git -C "$(sed -n 's/^sourceDir *= *"\(.*\)"/\1/p' ~/.config/chezmoi/chezmoi.toml 2>/dev/null)" log -1 --format='%cd' --date=short 2>/dev/null || echo 'dev')"

# ── 版本信息（简要） ──────────────────────────────────────
_greeting() {
  local green='\033[01;32m'
  local cyan='\033[01;36m'
  local yellow='\033[01;33m'
  local magenta='\033[01;35m'
  local dim='\033[02m'
  local reset='\033[00m'

  local version="${green}chezmoi${reset}-${cyan}${_CHEZMOI_VERSION}${reset}"

  local msg="${version}"

  # GNOME Terminal 主题名
  if command -v dconf >/dev/null 2>&1 && gsettings list-schemas 2>/dev/null | grep -q "org.gnome.Terminal"; then
    local _pid _tname
    _pid=$(gsettings get org.gnome.Terminal.ProfilesList list 2>/dev/null | tr -d "[]' " | head -1)
    if [ -n "$_pid" ]; then
      _tname=$(dconf read "/org/gnome/terminal/legacy/profiles:/:${_pid}/visible-name" 2>/dev/null | tr -d "'")
      [ -n "$_tname" ] && msg="${msg} | ${magenta}${_tname}${reset}"
    fi
  fi

  msg="${msg} | ${dim}type ${yellow}help${reset} ${dim}for more${reset}"

  echo -e "${msg}"
}

# ── 环境诊断 ──────────────────────────────────────────────
_chezmoi_check() {
  if command -v "$1" >/dev/null 2>&1; then
    echo -e "  $ok $1"
  else
    echo -e "  $no $1"
  fi
}

chezmoi-doctor() {
  local ok='\033[01;32m✓\033[00m'
  local no='\033[01;31m✗\033[00m'

  _greeting
  echo ""
  echo "Core tools:"
  _chezmoi_check git
  _chezmoi_check chezmoi
  _chezmoi_check curl
  _chezmoi_check jq

  echo ""
  echo "Editor & Terminal:"
  _chezmoi_check nvim
  _chezmoi_check vim
  _chezmoi_check tmux

  # Tmux 插件状态（仅 tmux 存在时检查）
  if command -v tmux >/dev/null 2>&1; then
    echo ""
    echo "Tmux Plugins:"
    if [ -d ~/.tmux/plugins/tpm ]; then
      echo -e "  $ok TPM (plugin manager)"
      local _plug_count
      _plug_count=$(find ~/.tmux/plugins -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
      echo -e "  $ok 已安装 ${_plug_count} 个插件"
    else
      echo -e "  $no TPM 未安装 (运行 help-tmux 查看安装方法)"
    fi
  fi

  echo ""
  echo "AI Tools:"
  _chezmoi_check claude
  _chezmoi_check codex
  _chezmoi_check copilot-api

  echo ""
  echo "AI Plugins:"
  _chezmoi_check claudeline

  echo ""
  echo "Languages & Runtimes:"
  _chezmoi_check go
  _chezmoi_check bun
  _chezmoi_check node
  _chezmoi_check conan

  echo ""
  echo "Network & Remote:"
  _chezmoi_check tailscale
  _chezmoi_check glab
  _chezmoi_check ssh

  echo ""
  echo "Clipboard:"
  if [ -n "$WAYLAND_DISPLAY" ]; then
    _chezmoi_check wl-copy
  elif [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ]; then
    _chezmoi_check clip.exe
  elif [ -n "$DISPLAY" ]; then
    _chezmoi_check xclip
  else
    echo -e "  $no 无剪贴板工具（非桌面环境）"
  fi

  echo ""
  echo "Config files:"
  for f in ~/.bash_aliases ~/.bash_local ~/.tmux.conf; do
    if [ -f "$f" ]; then
      echo -e "  $ok ${f/#$HOME/~}"
    else
      echo -e "  $no ${f/#$HOME/~}"
    fi
  done
}
