#!/usr/bin/env bash

_help_desc "ghostty" "终端" "Ghostty 安装要点、分屏与快捷键"

help-ghostty() {
  cat <<'EOF'
── Ghostty ─────────────────────────────────────────────────
  配置目录（Linux / XDG）:
    ~/.config/ghostty/config.ghostty       chezmoi 管理的主配置
    ~/.config/ghostty/config.local.ghostty   本机覆盖（首次生成，之后不覆盖）

  文档:
    chezmoi 源仓库内 docs/ghostty-setup.md（安装、默认终端、分屏）

  常用命令:
    ghostty +list-keybinds                 列出快捷键
    ghostty +list-themes                   列出内置主题名
    ghostty +show-config --default --docs  查看带注释的默认项

  重载配置:
    Ctrl+Shift+,                           默认「reload_config」（以 +list-keybinds 为准）

  分屏与 pane:
    Ctrl+Shift+O / Ctrl+Shift+E          向右 / 向下新开 split
    Ctrl+Alt+方向键                       焦点移到相邻 pane
    Super+Ctrl+[ / Super+Ctrl+]          上一个 / 下一个 pane（顺序）
    Ctrl+Shift+Enter                     放大或还原当前 pane
    Super+Ctrl+Shift+方向键               沿方向拖动分割线

  下载安装:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
EOF

  # 版本 < 24.04 时提示不兼容
  if [[ -f /etc/os-release ]]; then
    local ver
    ver=$(. /etc/os-release && echo "${VERSION_ID:-}")
    if [[ -n "$ver" ]] && awk "BEGIN{exit($ver >= 24.04 ? 1 : 0)}" 2>/dev/null; then
      printf '    \033[33m⚠  当前系统 Ubuntu %s — 上述脚本仅支持 24.04+，需从源码编译: https://ghostty.org/docs/install/build\033[0m\n' "$ver"
    fi
  fi

  cat <<'EOF'

  查看当前默认终端:
    readlink -f /usr/bin/x-terminal-emulator
    update-alternatives --display x-terminal-emulator   # 详细候选列表

  设为默认终端:
    # 手动安装时需先注册候选（apt 安装可跳过）:
    sudo update-alternatives --install /usr/bin/x-terminal-emulator \
      x-terminal-emulator /usr/bin/ghostty 50
    # 然后选中:
    sudo update-alternatives --set x-terminal-emulator /usr/bin/ghostty

  还原默认终端:
    sudo update-alternatives --auto x-terminal-emulator
    # 或交互选择:  sudo update-alternatives --config x-terminal-emulator

  其他常用默认:
    Ctrl+Shift+T / Ctrl+Shift+W            新标签 / 关标签
    Ctrl+Tab / Ctrl+Shift+Tab            下一个 / 上一个标签
    Ctrl+Shift+F                         搜索
    Ctrl+Shift+C / Ctrl+Shift+V          复制 / 粘贴
    Ctrl+加号 / Ctrl+减号 / Ctrl+0       字体放大、缩小、重置
────────────────────────────────────────────────────────────
EOF
}
