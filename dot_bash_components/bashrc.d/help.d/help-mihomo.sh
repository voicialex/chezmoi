#!/usr/bin/env bash

_help_desc "mihomo" "网络" "Mihomo (Clash.Meta) TUN 代理下载与使用"

help-mihomo() {
  cat <<'EOF'
── Mihomo ─────────────────────────────────────────────────────
  Mihomo (原 Clash.Meta) — 基于 Clash 内核的 TUN 模式透明代理

  [下载安装]
    # 去 https://github.com/MetaCubeX/mihomo/releases/latest 找到对应架构的 .gz 链接
    # amd64:
    curl -Lo mihomo.gz https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-amd64.gz
    # arm64:
    curl -Lo mihomo.gz https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-arm64.gz
    # armv7:
    curl -Lo mihomo.gz https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-armv7.gz
    # 通用后续步骤:
    gzip -d mihomo.gz
    chmod +x mihomo
    sudo mv mihomo /usr/local/bin/

  [首次配置]
    mkdir -p ~/.config/mihomo
    # 将订阅提供的 config.yaml 放入 ~/.config/mihomo/

  [启动与停止]
    # --- systemd（推荐，开机自启）---
    sudo systemctl enable --now mihomo    启动 + 开机自启
    sudo systemctl stop mihomo            停止

    # --- nohup 后台（无 systemd 时）---
    nohup mihomo -d ~/.config/mihomo > /tmp/mihomo.log 2>&1 &
    # 停止：pkill mihomo

    # --- 前台调试 ---
    mihomo -d ~/.config/mihomo            Ctrl+C 停止

  [状态查看]
    sudo systemctl status mihomo           systemd 方式
    pgrep -fl mihomo && echo "运行中"       nohup 方式
    curl -x http://127.0.0.1:7890 http://www.google.com -I  测试代理连通

  [代理范围说明]
    Mihomo 有两种工作模式，由 config.yaml 决定：

    TUN 模式（tun.enable: true）→ 代理所有流量
      系统全局生效，浏览器、终端、Docker 等所有应用自动走代理。
      无需单独配置，适合需要全局出海的场景。

    HTTP/SOCKS5 模式（仅开 listener）→ 按需代理
      只有显式配置了代理的应用才会走 mihomo：
        浏览器  装 SwitchyOmega 插件，指向 127.0.0.1:7890
        命令行  设置环境变量：
          export http_proxy=http://127.0.0.1:7890
          export https_proxy=http://127.0.0.1:7890
          export all_proxy=socks5://127.0.0.1:7893
        curl     curl -x http://127.0.0.1:7890 <URL>
        wget     wget -e http_proxy=http://127.0.0.1:7890 <URL>
        git      git -c http.proxy=http://127.0.0.1:7890 clone <URL>
        pip      pip install --proxy http://127.0.0.1:7890 <pkg>
        apt      sudo apt -o Acquire::http::proxy=http://127.0.0.1:7890 install <pkg>

  [订阅更新]
    # 替换 config.yaml 后热重载（无需重启）
    curl -X PUT http://127.0.0.1:9090/configs -d '{"path":""}'

  [Web 管理面板]
    # 搭配 metacubexd 面板：https://metacubexd.pages.dev
    # 访问后填入 API 地址 http://127.0.0.1:9090

  [常用端口]
    7890  HTTP 代理
    7893  SOCKS5 代理
    9090  RESTful API

  [卸载]
    sudo systemctl disable --now mihomo
    sudo rm -f /usr/local/bin/mihomo /etc/systemd/system/mihomo.service
    rm -rf ~/.config/mihomo
─────────────────────────────────────────────────────────────
EOF
}
