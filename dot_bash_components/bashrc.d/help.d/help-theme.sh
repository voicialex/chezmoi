#!/usr/bin/env bash

_help_desc "theme" "系统" "终端主题切换"

help-theme() {
  cat <<'EOF'
── 终端主题 ────────────────────────────────────────────────
  查看可用主题:
    theme
    theme list

  切换主题（支持 Tab 补全）:
    theme catppuccin-mocha      柔和舒适，长时间使用最舒服
    theme tokyo-night           深蓝日系风格，辨识度高
    theme nord                  北极冷色调，极简干净

  注意:
    仅适用于 GNOME Terminal；WSL 下没有就不会提供这个命令
    切换后重新打开终端生效
    主题配置由 chezmoi 管理，新机器 apply 自动部署
    添加新主题: 在 ~/.config/gnome-terminal/themes/ 下新建 .theme 文件
─────────────────────────────────────────────────────────────
EOF
}
