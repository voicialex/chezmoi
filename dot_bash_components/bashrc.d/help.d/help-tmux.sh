#!/usr/bin/env bash

_help_desc "tmux" "编辑器" "Tmux 快捷键与使用流程"

help-tmux() {
  cat <<'EOF'
── Tmux ─────────────────────────────────────────────────────
  三层结构: Session > Window > Pane
    Session  会话     独立工作区，断网不丢失       tmux new -s work
    Window   窗口     会话内的标签页，底部状态栏显示 Ctrl+b c
    Pane     窗格     窗口内的分屏区域             Ctrl+b % / Ctrl+b "

  日常流程:
    tmux ls                      查看所有会话
    tmux new -s work             创建 work 会话
    tmux attach -t work          断网后重连恢复
    tmux kill-session -t work    彻底结束会话
    tmux new-session -A -s dev   有 dev 就恢复，没有就创建
    tmux list-panes -a -F '#{pane_id}'  列出所有窗格 ID
  参数说明:
    -s dev                       把会话名字设成 dev
    -A                           若 dev 已存在则直接附着，避免重复创建报错

  会话控制:
    Ctrl+b d                     脱离当前会话，后台继续运行
    Ctrl+b $                     重命名当前会话
    Ctrl+b s                     列出所有会话（交互选择切换）
    tmux detach-client           用命令行脱离当前会话
    tmux kill-session -t <name>  彻底结束指定会话

  脱离 vs 退出:
    脱离: Ctrl+b d 或 tmux detach-client
    结果: 只是离开 tmux，会话和程序继续运行
    退出: exit 或 Ctrl+d
    结果: 关闭当前 pane 的 shell；如果这是最后一个窗口/窗格，会话也会结束

  窗格操作:
    Ctrl+b %                     左右分屏
    Ctrl+b "                     上下分屏
    Ctrl+b z                     当前窗格全屏放大 / 再按恢复分屏
    Ctrl+b x                     关闭当前窗格
    Ctrl+h/j/k/l                 Vim 风格切换窗格（无需 prefix）

  右侧窗格放大与恢复:
    Ctrl+l → Ctrl+b z            切到右边并放大全屏
    Ctrl+b z                     恢复左右分屏

  窗口操作:
    Ctrl+b c                     新建窗口
    Ctrl+b <数字>                 切换窗口
    Ctrl+b ,                     重命名当前窗口
    Ctrl+b w                     列出所有窗口（交互选择切换）
    Ctrl+b &                     关闭当前窗口

  会话恢复 (resurrect + continuum):
    Ctrl+b Ctrl+s                手动保存会话布局
    Ctrl+b Ctrl+r                手动恢复会话布局
    说明: continuum 每 15 分钟自动保存；tmux 启动时自动恢复上次会话
    清除保存: rm ~/.local/share/tmux/resurrect/*.txt  （插件无删除命令，手动删文件即可）

  插件管理 (TPM):
    首次安装 TPM:
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      安装后按 prefix + I 安装所有插件，或 tmux kill-server 后重启
    日常管理:
      Ctrl+b I                     安装新插件（tmux.conf 里新加的插件）
      Ctrl+b U                     更新所有插件
      Ctrl+b alt+u                 清理未使用插件
    重载配置:
      Ctrl+b r                     快捷重载（已绑定）
      Ctrl+b : source-file ~/.tmux.conf   命令行方式

  复制粘贴（自动同步系统剪贴板）:
    ── 键盘操作 ──
    Ctrl+b [                     进入复制模式
    h/j/k/l                      移动光标
    v                            开始选择文本
    y                            复制选中内容 → 同时写入系统剪贴板
    Ctrl+b ]                     tmux 内粘贴

    ── 鼠标操作 ──
    鼠标左键拖动                  选中文字，松开自动复制 → 同时写入系统剪贴板
    Ctrl+b ]                     tmux 内粘贴

    ── 系统剪贴板粘贴 ──
    Ctrl+Shift+v                 粘贴系统剪贴板内容（在任意应用可用）

    ── 剪贴板工具（自动检测）──
    Wayland:  wl-copy            安装: sudo apt install wl-clipboard
    X11:      xclip              安装: sudo apt install xclip
    WSL:      clip.exe           系统自带，无需安装
    未安装时: 退回 tmux 内部缓冲区（Ctrl+b ] 仍可粘贴）

  配置文件:
    ~/.tmux.conf                 chezmoi 管理，修改后 Ctrl+b : source-file ~/.tmux.conf
─────────────────────────────────────────────────────────────
EOF
}
