#!/usr/bin/env bash
# 环境诊断工具：greeting 横幅 + chezmoi-doctor 检查命令
# 位于 bashrc.d/，由 bashrc.tmpl 自动加载

# ── 共享检测函数 ──────────────────────────────────────────

# 版本号（延迟计算，首次访问时才执行 git）
_CHEZMOI_VERSION=""
_chezmoi_version() {
  [ -n "$_CHEZMOI_VERSION" ] && return
  local _src=""
  _src="$(chezmoi source-path 2>/dev/null)" || _src=""
  [ -z "$_src" ] && _src="$(sed -n 's/^sourceDir *= *"\(.*\)"/\1/p' ~/.config/chezmoi/chezmoi.toml 2>/dev/null)"
  # Fallback: common source directory locations
  [ -z "$_src" ] || [ ! -d "$_src/.git" ] && _src="$HOME/.local/share/chezmoi"
  [ ! -d "$_src/.git" ] && _src="$HOME/workspace/software/chezmoi"
  _CHEZMOI_VERSION="v$(git -C "$_src" log -1 --format='%cd' --date=short 2>/dev/null || echo 'dev')"
}

# GNOME Terminal profile ID（greeting 和 theme 共用）
_gnome_profile_id() {
  gsettings get org.gnome.Terminal.ProfilesList list 2>/dev/null | tr -d "[]' " | head -1
}

# GPU 信息（多显卡 + nvidia-smi fallback）
_gpu_info() {
  local _gpus _count _i _total _line _name _mem

  # 优先 lspci（显示所有显卡包括集显）
  _gpus=$(lspci 2>/dev/null | grep -iE 'vga|3d' | sed 's/.*: //')
  if [ -n "$_gpus" ]; then
    _count=$(printf '%s\n' "$_gpus" | wc -l)
    if [ "$_count" -le 1 ]; then
      echo "  GPU: ${_gpus}"
    else
      echo "  GPUs:"
      _total=$_count
      _i=0
      while IFS= read -r _line; do
        _i=$((_i + 1))
        if [ "$_i" -eq "$_total" ]; then
          echo "  └─ ${_line}"
        else
          echo "  ├─ ${_line}"
        fi
      done <<< "$_gpus"
    fi
    return
  fi

  # Fallback: nvidia-smi（WSL 或无 lspci）
  command -v nvidia-smi >/dev/null 2>&1 || return
  _gpus=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader 2>/dev/null) || return
  [ -z "$_gpus" ] && return

  _count=$(printf '%s\n' "$_gpus" | wc -l)
  if [ "$_count" -le 1 ]; then
    _name=$(printf '%s' "$_gpus" | cut -d',' -f1 | sed 's/^ *//')
    _mem=$(printf '%s' "$_gpus" | cut -d',' -f2 | sed 's/^ *//')
    echo "  GPU: ${_name} (${_mem})"
  else
    echo "  GPUs:"
    _total=$_count
    _i=0
    while IFS=',' read -r _name _mem; do
      _i=$((_i + 1))
      _name=$(echo "$_name" | sed 's/^ *//')
      _mem=$(echo "$_mem" | sed 's/^ *//')
      if [ "$_i" -eq "$_total" ]; then
        echo "  └─ ${_name} (${_mem})"
      else
        echo "  ├─ ${_name} (${_mem})"
      fi
    done <<< "$_gpus"
  fi
}

# ── 版本信息（简要） ──────────────────────────────────────
_greeting() {
  _chezmoi_version

  local green='\033[01;32m'
  local cyan='\033[01;36m'
  local yellow='\033[01;33m'
  local magenta='\033[01;35m'
  local dim='\033[02m'
  local reset='\033[00m'

  local version="${green}chezmoi${reset}-${cyan}${_CHEZMOI_VERSION}${reset}"
  local platform="${dim}$(uname -m)${reset}"

  local msg="${version} | ${platform}"

  # GNOME Terminal 主题名
  if command -v dconf >/dev/null 2>&1 && gsettings list-schemas 2>/dev/null | grep -q "org.gnome.Terminal"; then
    local _pid _tname
    _pid=$(_gnome_profile_id)
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

# 系统硬件信息
_system_info() {
  local _val

  # OS
  if [ -f /etc/os-release ]; then
    local _os_name _os_ver
    _os_name=$(sed -n 's/^NAME="\(.*\)"/\1/p' /etc/os-release)
    _os_ver=$(sed -n 's/^VERSION="\(.*\)"/\1/p' /etc/os-release)
    echo "  OS: ${_os_name} ${_os_ver} ($(uname -m))"
  else
    echo "  OS: $(uname -s) $(uname -m)"
  fi
  [ -n "${WSL_DISTRO_NAME:-}" ] && echo "  WSL: ${WSL_DISTRO_NAME}"

  # CPU
  _val=$(lscpu 2>/dev/null | sed -n 's/^Model name:\s*//p')
  [ -n "$_val" ] && echo "  CPU: ${_val} ($(lscpu 2>/dev/null | sed -n 's/^CPU(s):\s*//p') threads)"

  # GPU
  _gpu_info

  # Memory
  _val=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')
  [ -n "$_val" ] && echo "  Memory: ${_val} ($(free -h 2>/dev/null | awk '/^Mem:/{print $7}') available)"
}

# Tmux 插件列表
_tmux_plugins() {
  if ! command -v tmux >/dev/null 2>&1; then return; fi
  echo "    Tmux Plugins:"
  if [ -d ~/.tmux/plugins/tpm ]; then
    echo -e "      $ok TPM (plugin manager)"
    local _p _pname
    for _p in $(find ~/.tmux/plugins -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort); do
      _pname=$(basename "$_p")
      [ "$_pname" = "tpm" ] && continue
      echo -e "        $ok $_pname"
    done
  else
    echo -e "      $no TPM 未安装 (运行 help-tmux 查看安装方法)"
  fi
}

chezmoi-doctor() {
  local ok='\033[01;32m✓\033[00m'
  local no='\033[01;31m✗\033[00m'

  _greeting
  echo ""

  echo "System:"
  _system_info

  echo ""
  echo "Core tools:"
  _chezmoi_check git
  _chezmoi_check chezmoi
  _chezmoi_check curl

  echo ""
  echo "Editor & Terminal:"
  _chezmoi_check nvim
  _chezmoi_check lazygit
  _chezmoi_check vim
  _chezmoi_check tmux
  _tmux_plugins

  local _cbt
  _cbt=$(_clipboard_tool)
  if [ -n "$_cbt" ]; then
    echo -e "  $ok Clipboard: $_cbt (tmux + nvim)"
  else
    echo -e "  $no Clipboard: 无剪贴板工具 (tmux + nvim)"
  fi

  echo ""
  echo "AI Tools:"
  _chezmoi_check claude
  if command -v claude >/dev/null 2>&1; then
    if [[ -x "${HOME}/.claude/claudeline" ]]; then
      echo -e "    $ok claudeline"
    else
      echo -e "    $no claudeline"
    fi
  fi
  _chezmoi_check codex
  _chezmoi_check copilot-api
  _chezmoi_check ollama

  echo ""
  echo "Dev Tools:"
  _chezmoi_check cmake
  _chezmoi_check conan
  _chezmoi_check docker

  echo ""
  echo "Languages & Runtimes:"
  _chezmoi_check go
  _chezmoi_check bun
  _chezmoi_check node

  echo ""
  echo "Network & Remote:"
  _chezmoi_check tailscale
  _chezmoi_check glab
  _chezmoi_check ssh

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
