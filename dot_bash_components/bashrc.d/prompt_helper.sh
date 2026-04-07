#!/usr/bin/env bash

# 通用 bash 帮助函数与速查内容（原 bash_helper/common.sh）

help() {
  # 有参数时回退到 bash 内建 help（如 help cd）
  if [ $# -gt 0 ]; then
    builtin help "$@"
    return
  fi
  echo "可用帮助主题："
  echo "  help-claude   Claude Code 常用命令"
  echo "  help-glm_claude  GLM 接入 Claude Code"
  echo "  help-codex    Codex 常用命令"
  echo "  help-terminal 终端输入编辑与通用快捷键"
  echo "  help-git      Git 常用命令（含 worktree）"
  echo "  help-glab     GitLab CLI 下载与常用命令"
  echo "  help-tmux     Tmux 快捷键与使用流程"
  echo "  help-nvim     Neovim (LazyVim) 使用"
  echo "  help-vim      Vim 常用操作"
  echo "  help-ssh      SSH 常用命令"
  echo "  help-copilot  copilot-api 启动/停止"
  echo "  help-tailscale Tailscale 远程组网速查"
  echo "  help-theme    终端主题切换"
  echo "  help-conan    Conan C/C++ 包管理速查"
  echo "  help-net      网络工具速查（nc/nmap/arp-scan/iftop/nethogs）"
  echo "  help-chezmoi  Chezmoi dotfile 管理速查"
}

help-codex() {
  cat <<'EOF'
── Codex ───────────────────────────────────────────────────
  安装（npm）:
    npm install -g @openai/codex

  启动:
    codex

  查看帮助:
    codex --help
    codex exec --help
    codex login --help

  登录状态:
    codex login status

  半自动模式（低打断，仍在沙箱内）:
    codex exec --full-auto "你的任务"
    等价于:
    codex exec -a on-request --sandbox workspace-write "你的任务"

  全权限危险模式（跳过审批+关闭沙箱）:
    codex exec --dangerously-bypass-approvals-and-sandbox "你的任务"

  单次执行:
    codex exec "帮我检查当前仓库里最近的改动"

  跳过 Git 仓库检查执行:
    codex exec --skip-git-repo-check "输出当前目录说明"

  指定沙箱模式:
    codex exec --sandbox read-only "只读分析这个项目"
    codex exec --sandbox workspace-write "修复一个小问题并直接改代码"

  JSON 输出:
    codex exec --json "Reply with OK only."

  常用速记:
    codex                  进入交互模式
    /help                  查看会话内命令
    /model                 查看或切换模型
    /approvals             查看权限策略

  终端输入编辑:
    help-terminal         查看 Ctrl+A / Ctrl+U / Ctrl+R 等通用输入技巧

  典型用法:
    codex
    codex exec --full-auto "帮我修一个小问题并直接修改代码"
    codex exec --dangerously-bypass-approvals-and-sandbox "直接处理当前仓库中的问题"
    codex exec --sandbox read-only "分析 perception_app 的模块结构"
    codex exec --sandbox workspace-write "为 build.sh 增加一个 --help 说明"
─────────────────────────────────────────────────────────────
EOF
}

help-terminal() {
  cat <<'EOF'
── Terminal Line Editing ────────────────────────────────────
  说明:
    下面这些多半是终端行编辑能力，不是 Codex / Claude Code 私有命令
    所以在 bash、很多 REPL、Codex 终端版、Claude Code 终端版里通常通用
    但如果某个程序自己接管按键，个别快捷键可能失效或行为不同

  光标移动:
    Ctrl+A                移到行首
    Ctrl+E                移到行尾
    Alt+B                 按单词向左跳
    Alt+F                 按单词向右跳

  删除输入:
    Ctrl+U                删除光标左侧整段内容
    Ctrl+K                删除光标右侧整段内容
    Ctrl+W                删除左侧一个单词
    Ctrl+Backspace        常见为删除左侧一个单词，但依赖终端映射
    Alt+D                 删除右侧一个单词，部分终端可能不一致

  历史与恢复:
    Ctrl+R                反向搜索历史输入
    Ctrl+Y                粘贴刚刚删除的内容
    Ctrl+L                清屏，但不清当前输入

  最常用组合:
    Ctrl+U                快速清空当前行
    Ctrl+W                逐词回删
    Ctrl+A 然后 Ctrl+K    保留左侧，删掉整段尾部
    Ctrl+R                搜以前问过的话或执行过的命令

  在图形输入框中:
    Ctrl+A, Backspace     全选后删除，通常最稳妥

  和 AI 工具命令的区别:
    Ctrl+A / Ctrl+U / Ctrl+R 这类是终端输入编辑，通常跨工具通用
    /help /model /approvals   这类是应用命令，只在具体工具里生效

  判断规则:
    如果是在“发送前编辑这一行”，大概率是终端通用能力
    如果是在“控制会话、切模型、看权限”，那通常是工具私有命令
─────────────────────────────────────────────────────────────
EOF
}

help-git() {
  cat <<'EOF'
── Git ──────────────────────────────────────────────────────
  [worktree]
    git worktree list                         查看 worktree 列表
    git worktree add ../new-dir branch-name   在新目录检出已有分支
    git worktree add -b new-branch ../new-dir base-branch
                                               基于 base-branch 新建并检出分支
    git worktree remove ../new-dir            删除指定 worktree
    git worktree prune                        清理失效 worktree 记录

  [rebase]
    git rebase -i HEAD~3                      交互式整理最近 3 个提交
    git rebase -i <commit_id>                从指定提交之后开始整理
    pick / reword / squash / fixup / drop    常用动作

  [push]
    git push origin <branch> --force-with-lease
                                               安全强推，替代 git push -f

  [merge]
    git merge --no-ff <branch>                保留 merge commit 合并分支
    git merge --squash <branch>               压成一次提交后再统一 commit

  [show]
    git show --stat <commit_sha>             查看提交改动文件
    git show <commit_sha>                    查看提交详细内容
    git show HEAD:<文件>                     查看已删除文件的内容（上一次提交）
    git show HEAD~1:<文件>                   查看更早一次提交的文件内容
    git diff HEAD -- <文件>                  对比当前与上次提交的差异（含删除）
EOF

  echo "  [alias] 自定义别名（~/.gitconfig.d/alias.conf）"
  if [ -f "$HOME/.gitconfig.d/alias.conf" ]; then
    local alias_lines
    alias_lines="$(
      awk '
        /^\[alias\]/ { in_alias = 1; next }
        /^\[/ { in_alias = 0 }
        in_alias {
          line = $0
          sub(/^[[:space:]]+/, "", line)
          if (line == "" || line ~ /^[#;]/) {
            next
          }
          pos = index(line, "=")
          if (pos == 0) {
            next
          }
          name = substr(line, 1, pos - 1)
          cmd = substr(line, pos + 1)
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", cmd)
          if (name != "" && cmd != "") {
            printf "    git %-36s %s\n", name, cmd
          }
        }
      ' "$HOME/.gitconfig.d/alias.conf"
    )"
    if [ -n "$alias_lines" ]; then
      printf '%s\n' "$alias_lines"
    else
      echo "    （未发现可解析的 alias 条目）"
    fi
  else
    echo "    （未找到 ~/.gitconfig.d/alias.conf）"
  fi

  cat <<'EOF'

  [注意]
    同一个分支不能同时被多个 worktree 检出
    删除 worktree 前先确认目录里没有未提交改动
    优先用 git worktree remove，不要手动删 .git/worktrees
─────────────────────────────────────────────────────────────
EOF
}

help-glab() {
  cat <<'EOF'
── glab / GitLab CLI ───────────────────────────────────────
  下载（Ubuntu，推荐 .deb；snap 在 WSL/容器里常不可用）:
    curl -LO https://gitlab.com/gitlab-org/cli/-/releases/permalink/latest/downloads/glab_amd64.deb
    # curl -LO https://gitlab.com/gitlab-org/cli/-/releases/v1.92.1/downloads/glab_1.92.1_linux_amd64.deb
    sudo apt install ./glab_amd64.deb

  验证版本:
    glab --version

  登录:
    glab auth login
    glab auth status

  token 获取:
    GitLab 网页 -> 头像 -> Preferences / Edit profile -> Access Tokens
    常用 scope: api

  最常用:
    glab repo view
    glab mr list
    glab mr view <mr_iid>
    glab mr checks <mr_iid>

  当前分支发起合并到 develop:
    glab mr create --source-branch feature-dev --target-branch develop --fill

  指定标题和描述创建 MR:
    glab mr create \
      --source-branch feature-dev \
      --target-branch develop \
      --title "feat(Guard): [CCAR-9530] Update tracking topic" \
      --description "Merge feature-dev into develop"

  查看/签出 MR:
    glab mr view <mr_iid>
    glab mr checkout <mr_iid>

  备注:
    先把本地 feature-dev push 到 origin，再创建目标为 develop 的 MR
    如果做过 rebase，推送时用: git push origin feature-dev --force-with-lease
─────────────────────────────────────────────────────────────
EOF
}

help-glm_claude() {
  cat <<'EOF'
── GLM Claude ──────────────────────────────────────────────
  接入 GLM（智谱自动化助手）:
    npx @z_ai/coding-helper
    或:
    curl -O "https://cdn.bigmodel.cn/install/claude_code_env.sh" && bash ./claude_code_env.sh

  说明:
    用于将 GLM Coding Plan 接入 Claude Code
    按界面提示完成工具安装、套餐配置与 MCP 管理

  手动配置:
    编辑 `~/.claude/settings.json`:
    {
      "env": {
        "ANTHROPIC_AUTH_TOKEN": "your_zhipu_api_key",
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "API_TIMEOUT_MS": "3000000",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
      }
    }

    再编辑或新增 `~/.claude.json`:
    {
      "hasCompletedOnboarding": true
    }
─────────────────────────────────────────────────────────────
EOF
}

help-claude() {
  cat <<'EOF'
── Claude Code ──────────────────────────────────────────────
  安装（npm）:
    npm install -g @anthropic-ai/claude-code

  启动（跳过权限确认）:
    claude --dangerously-skip-permissions

  恢复/保存/重命名会话:
    claude --dangerously-skip-permissions -c
    /resume <session-name>
    /save   <session-name>
    /rename <session-name>
    /context 查询当前会话上下文信息

  Agent Teams 模式:
    CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 \
      claude --dangerously-skip-permissions --teammate-mode tmux
    CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 \
      claude --dangerously-skip-permissions --teammate-mode in-process
─────────────────────────────────────────────────────────────
EOF
}

help-copilot() {
  cat <<'EOF'
── copilot-api 代理 ─────────────────────────────────────────
  后台启动:
    nohup copilot-api start &> ~/.local/share/copilot-api/server.log &

  停止:
    pkill -f "copilot-api start"

  查看日志:
    tail -f ~/.local/share/copilot-api/server.log

  验证运行:
    ss -tulpn | grep 4141
    curl http://localhost:4141/v1/models

  重新认证:
    copilot-api auth
  查询使用情况:
    npx copilot-api check-usage

── Copilot CLI ──────────────────────────────────────────────
  启动（允许所有工具）:
    copilot --allow-all-tools

  启动（禁用指定工具，如禁止 git push）:
    copilot --deny-tool='shell(git push)'

  多条规则叠加:
    copilot --allow-all-tools --deny-tool='shell(git push)' \
            --deny-tool='shell(rm -rf)'
─────────────────────────────────────────────────────────────
EOF
}

help-net() {
  cat <<'EOF'
── 网络工具速查 ───────────────────────────────────────────
  [curl]  测网站是否通（最靠谱，看 HTTP 状态码）
    curl -sI https://github.com | head -1       返回 200 就是通的
    curl -s --fail URL >/dev/null && echo 通     脚本判断通/不通

  [ping]  测主机连通（发 ICMP 敲门包，部分网站会屏蔽，不如 curl 准）
    ping -c 4 github.com

  [nc]    测端口是否开放 / 临时传文件
    nc -zv 192.168.1.100 22                     测端口
    nc -l 9999 > file.txt                       接收端
    nc 目标IP 9999 < file.txt                   发送端

  [nmap]  网段扫描（主机发现 / 端口 / 服务版本）
    nmap -sn 192.168.1.0/24                     存活主机
    nmap -sV 192.168.1.100                      端口+服务版本
    nmap -F 192.168.1.100                       快速扫描

  [arp-scan]  局域网设备盘点（IP + MAC）
    sudo arp-scan -l                            默认网卡
    sudo arp-scan -I eth0 -l                    指定网卡

  [iftop]  实时网卡流量（谁在占带宽）
    sudo iftop -i eth0
    交互: t 模式  s 按源  d 按目的  p 显示端口

  [nethogs]  按进程看流量（哪个进程在跑）
    sudo nethogs eth0
    交互: m 切换单位  r 排序  q 退出

  [ip]  网卡地址管理
    sudo ip addr replace 192.168.2.120/24 dev eth0   替换 IP
    sudo ip addr add     192.168.2.120/24 dev eth0   新增 IP
    ip -4 addr show dev eth0                          查看结果
─────────────────────────────────────────────────────────────
EOF
}

help-tailscale() {
  cat <<'EOF'
── Tailscale ───────────────────────────────────────────────
  [日常使用]
    tailscale status                  查看所有在线设备及 IP
    tailscale ip                      查看本机 Tailscale IP
    tailscale ping <设备名或IP>        测试连通性（显示直连/中继）

  [连接管理]
    sudo tailscale up                 启动并登录
    sudo tailscale down               断开网络（不卸载，随时恢复）
    sudo tailscale logout             登出账号
    sudo tailscale up --reset         重置所有配置重新开始

  [网络诊断]
    tailscale netcheck                检测网络质量、NAT 类型、DERP 延迟
    tailscale whois <IP>              查某个 IP 对应的设备和用户

  [其他]
    tailscale version                 查看版本
    tailscale update                  更新到最新版
    tailscale file cp <文件> <设备名>:  通过 Tailscale 传文件

  [SSH 快捷连接]
    ssh NvServer                      连接远程服务器（已配置 ~/.ssh/config）
─────────────────────────────────────────────────────────────
EOF
}

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

help-conan() {
  cat <<'EOF'
── Conan 1（必要功能分类）────────────────────────────────────
  [1) 环境确认]
    conan --version
    conan profile list
    conan profile show <your_profile>

  [2) 打包导出]
    conan export-pkg -f -pf <package_folder> conanfile.py <user>/<channel> \
      -pr <your_profile> -s build_type=<Release|Debug> \
      -o <name>:<option1>=<value1> -o <name>:<option2>=<value2>

  [3) 导出校验]
    conan search <name>/<version>@<user>/<channel>
    conan search <name>/<version>@<user>/<channel> --revisions
    conan inspect <name>/<version>@<user>/<channel> -a options

  [4) 发布上传]
    conan upload <name>/<version>@<user>/<channel> --all -r <remote>

  [5) 消费安装]
    conan remove <name>/<version>@<user>/<channel> -f
    conan install . -pr <your_profile> -s build_type=<Release|Debug> \
      -o <name>:<option1>=<value1> \
      -o <name>:<option2>=<value2> \
      --update

  [6) conan install 常用功能]
    # 基础安装（缺什么补什么）
      conan install . --build=missing
    # 指定 profile / build_type
    conan install . -pr <your_profile> -s build_type=Debug
    # 指定 options
    conan install . -o <name>:<option>=<value>
    # 强制从远端更新
    conan install . --update

  [示例（safety-function）]
    conan export-pkg -f -pf output/safety-function conanfile.py guard/stable \
      -pr aarch64_gcc12.2 -s build_type=Release \
      -o enable_hsd=False -o enable_flat_proto_msg=True
    conan search safety-function/0.0.0@guard/stable --revisions
    conan upload safety-function/0.0.0@guard/stable --all -r conan-test
    conan remove safety-function/0.0.0@guard/stable -f
    conan install . -pr aarch64_gcc12.2 -s build_type=Release \
      -o safety-function:enable_hsd=False \
      -o safety-function:enable_flat_proto_msg=True \
      --update
─────────────────────────────────────────────────────────────
EOF
}

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

help-ssh() {
  cat <<'EOF'
── SSH ──────────────────────────────────────────────────────
  复制公钥到远端:
    ssh-copy-id jetson@192.168.2.100

  清除旧 host key（IP 变了时用）:
    ssh-keygen -R 192.168.2.99
─────────────────────────────────────────────────────────────
EOF
}

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
  参数说明:
    -s dev                       把会话名字设成 dev
    -A                           若 dev 已存在则直接附着，避免重复创建报错

  会话控制:
    Ctrl+b d                     脱离当前会话，后台继续运行
    Ctrl+b $                     重命名当前会话
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
    Ctrl+b &                     关闭当前窗口

  会话恢复 (resurrect + continuum):
    Ctrl+b Ctrl+s                手动保存会话布局
    Ctrl+b Ctrl+r                手动恢复会话布局
    说明: continuum 每 15 分钟自动保存；tmux 启动时自动恢复上次会话

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

help-nvim() {
  cat <<'EOF'
── Neovim (LazyVim) ────────────────────────────────────────
  安装位置:
    /opt/nvim/bin/nvim           可执行文件
    ~/.config/nvim               配置目录（LazyVim）

  首次启动:
    nvim                         直接运行，LazyVim 会自动安装所有插件
                                 等待右下角提示消失（约 1-2 分钟）
                                 安装完成后按 q 关闭面板，再按 :q 退出
    第二次打开就不会再安装了

  打开项目:
    nvim .                       打开当前目录作为项目（最常用）
    nvim ~/my-project            打开指定目录作为项目
    nvim main.py                 直接打开单个文件
    cd ~/my-project && nvim .    先进项目目录，再打开（推荐）

  打开项目后的第一步:
    1. Space e                   打开左侧文件树，浏览项目结构
    2. 用 j/k 上下移动选择文件
    3. 按 Enter 打开文件
    4. Space Space                全局搜索文件名，快速跳转
    5. Space /                    全局搜索文件内容

  退出:
    :q                           关闭当前文件
    :qa                          关闭所有文件退出
    :wq                          保存并关闭
    :q!                          不保存强制退出

  插件管理:
    :Mason                       管理语言 Server（LSP/格式化/调试）
                                 搜索 → i 安装 → X 卸载
    :Lazy                        總理插件（更新/清理）

  文件与搜索 (前缀 Space):
    Space e                      文件树（neo-tree）
    Space Space                  全局搜索文件名
    Space /                      全局搜索文件内容
    Space f r                    最近打开的文件

  代码导航:
    gd                           跳到定义（go definition）
    gr                           查看引用（go references）
    K                            查看悬停文档
    Ctrl+o                       跳回上一个位置
    Ctrl+i                       跳到下一个位置

  编辑:
    gcc                          注释/取消注释当前行
    gc（可视模式）                注释/取消注释选中区域

  窗口操作:
    Ctrl+h/j/k/l                 在窗格间移动
    Ctrl+w v                     垂直分屏
    Ctrl+w s                     水平分屏
    Ctrl+w q                     关闭当前窗格

  终端（LazyVim 默认 Snacks）:
    Ctrl+/                       切换当前唯一浮动终端（单例）
    数字 + Ctrl+/                1<C-/> / 2<C-/> 打开或切换编号终端
    Ctrl+\ Ctrl+n                从终端模式回到普通模式
    i                              在终端窗口中进入终端输入模式

  文件比较（Diff）:
    nvim -d file1 file2          终端启动，垂直分屏对比两个文件
    :vert diffsplit file2        在 nvim 内对比当前文件和 file2
    ]c                           跳到下一个差异处
    [c                           跳到上一个差异处
    dp                           把当前差异推到另一边（diff put）
    do                           从另一边拉取差异到当前（diff obtain）
    :diffupdate                  手动刷新差异

  Git Diff（比较当前文件改动）:
    Space g h d                  对比当前文件 vs 暂存区（垂直分屏）
    Space g h D                  对比当前文件 vs 上一次 commit（HEAD~1）
    Space g h p                  浮动窗口预览当前改动块（按 q 关闭）
    ]h                           跳到下一个改动块
    [h                           跳到上一个改动块
    Space g f                    查看当前文件所有 commit 历史（选中预览 diff）

  关闭比较窗口:
    :q                           关闭当前分屏窗格（光标在哪个窗格就关哪个）
    Ctrl+w q                     同上，关闭当前窗格

  文件切换（最常用）:
    Ctrl+^                       当前文件 ↔ 上一个文件（两个文件来回横跳）
    ]b                           下一个 buffer（多文件前进）
    [b                           上一个 buffer（多文件后退）

  参考:
    ~/chezmoi/docs/nvim-setup.md 安装文档
    ~/.config/nvim               配置目录（chezmoi 管理自定义文件）
─────────────────────────────────────────────────────────────
EOF
}

help-vim() {
  cat <<'EOF'
── Vim ──────────────────────────────────────────────────────
一、模式切换

  按键       作用                     说明
  ──────────────────────────────────────────────────────
  i          光标前插入               最常用的进入编辑方式
  a          光标后插入               追加内容时用
  o          下一行新建行插入         快速在当前行下面写新行
  O（大写）  上一行新建行插入         在当前行上面插入
  I（大写）  行首插入                 跳到行头再进编辑
  A（大写）  行尾插入                 跳到行尾再进编辑
  Esc        退回普通模式             任何时候按 Esc 都安全

──────────────────────────────────────────────────────────────
二、选择 → 复制 → 粘贴

  1. 选择文本（可视模式）
  按键       作用                     说明
  ──────────────────────────────────────────────────────
  v          字符级选择               移动光标即可扩展选区
  V（大写）  行级选择                 选整行更高效
  Ctrl+v     块级矩形选择             选表格 / 多列代码超实用

  2. 复制
  按键   作用                         说明
  ──────────────────────────────────────────────────────
  y      复制已选中内容               先选文本再按 y
  yy     复制当前整行                 不需要先选，直接按
  3yy    向下复制 3 行                数字 + yy 批量复制
  y$     复制光标到行尾               精准复制行内片段

  3. 粘贴
  按键       作用                     说明
  ──────────────────────────────────────────────────────
  p          粘贴到光标下方/右侧      最常用
  P（大写）  粘贴到光标上方/左侧      贴到当前位置之前

──────────────────────────────────────────────────────────────
三、撤销 / 重做

  按键       作用                     说明
  ──────────────────────────────────────────────────────
  u          撤销（undo）             反复按可多步撤销
  Ctrl+r     重做（redo）             把撤销的操作再做回来
  .（点号）  重复上一次操作           超实用，省重复劳动

──────────────────────────────────────────────────────────────
四、查找 / 替换

  查找
  按键       作用                     说明
  ──────────────────────────────────────────────────────
  /word      向下查找 word            回车确认，高亮匹配
  ?word      向上查找 word            方向相反
  n          跳到下一个匹配           配合 / 或 ? 使用
  N（大写）  跳到上一个匹配           反向跳转

  替换（命令模式）
  命令                      作用
  ──────────────────────────────────────────────────────
  :%s/old/new/g             全文替换，不确认
  :%s/old/new/gc            全文替换，逐个确认（y=替换 n=跳过）
  :10,20s/old/new/g         只替换第 10~20 行

──────────────────────────────────────────────────────────────
五、相对行号操作（relativenumber）

  左侧显示的是距离当前行的行数，看到几就按几，不用心算：
  按键       作用
  ──────────────────────────────────────────────────────
  3j         向下移动 3 行
  5k         向上移动 5 行
  5dd        删除当前行及下方 4 行（共 5 行）
  4yy        复制当前行及下方 3 行（共 4 行）
  d3k        删除当前行到上方 3 行
  y4j        复制当前行到下方 4 行
  c2j        修改当前行到下方 2 行（删除并进入插入模式）
  >5j        将下方 5 行右缩进
  <3j        将下方 3 行左缩进
  V6j        可视选中当前行到下方 6 行

─────────────────────────────────────────────────────────────
EOF
}
