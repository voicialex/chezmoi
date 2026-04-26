#!/usr/bin/env bash

_help_desc "tailscale" "系统" "Tailscale 远程组网速查"

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
