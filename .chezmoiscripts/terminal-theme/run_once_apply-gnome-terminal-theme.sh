#!/usr/bin/env bash
# 首次部署时应用默认终端主题（Catppuccin Mocha）
# 复用 gnome-terminal-theme.sh 里的 _theme_apply 函数，避免重复代码
# 非 GNOME Terminal 环境自动跳过

THEME_SH="$HOME/.bash_components/bashrc.d/gnome-terminal-theme.sh"
THEME_FILE="$HOME/.config/gnome-terminal/themes/catppuccin-mocha.theme"

# 依赖 chezmoi 先部署文件再执行脚本的顺序保证
[ -r "$THEME_SH" ] || exit 0
[ -r "$THEME_FILE" ] || exit 0

# 加载 theme 函数（包括 _theme_available / _theme_apply）
# shellcheck disable=SC1090
. "$THEME_SH"

_theme_available || exit 0
_theme_apply "$THEME_FILE"
