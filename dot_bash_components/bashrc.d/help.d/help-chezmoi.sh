#!/usr/bin/env bash

_help_desc "chezmoi" "管理" "Chezmoi dotfile 管理速查"

help-chezmoi() {
  cat <<'EOF'
── Chezmoi（dotfile 管理）──────────────────────────────────
  [日常操作]
    chezmoi diff                          预览改动，应用前先看
    chezmoi apply                         部署到 $HOME
    chezmoi apply ~/.bashrc               只部署单个文件
    chezmoi status                        查看哪些文件有变动

  [编辑]
    chezmoi edit ~/.bashrc                用 $EDITOR 编辑源文件
    chezmoi cd                            进入源目录（~/chezmoi）

  [多机同步]
    git push（本地）                       提交并推送改动
    chezmoi update                        远程机器拉取最新（等价 git pull）
    chezmoi update && chezmoi apply       远程机器一键拉取+部署

  [新机器初始化]
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/voicialex/chezmoi.git

  [调试]
    chezmoi source-path                   查看源目录位置
    chezmoi target-path                   查看部署目标路径
    chezmoi data                          查看模板变量（OS、主机名等）
    chezmoi doctor                        检查 chezmoi 环境状态

  [WSL 下管理 VSCode/Cursor 快捷键]
    编辑 ~/.config/editor-keybindings/vscode-keybindings.jsonc
    编辑 ~/.config/editor-keybindings/cursor-keybindings.jsonc
    chezmoi apply                         自动同步到 Windows AppData
    Windows 目标:
      AppData/Roaming/Code/User/keybindings.json
      AppData/Roaming/Cursor/User/keybindings.json

  [文件命名规则]
    dot_foo        → ~/.foo              点号前缀
    dot_foo.tmpl   → ~/.foo              Go 模板
    create_dot_foo → ~/.foo              只创建不覆盖
    modify_ 只能用于文件，不能用于目录
      例: dot_ssh/modify_config  → 修改 ~/.ssh/config
    private_dot_foo → ~/.foo             权限 600
    run_once_foo.sh                       只执行一次的脚本
    run_foo.sh                            每次 apply 都执行（必须幂等）
    .chezmoiscripts/<domain>/run_*.sh     推荐：脚本按功能分组
    .chezmoiignore.tmpl                   条件忽略（支持 lookPath 检测工具）
─────────────────────────────────────────────────────────────
EOF
}
