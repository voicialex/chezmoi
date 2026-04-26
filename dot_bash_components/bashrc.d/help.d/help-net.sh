#!/usr/bin/env bash

_help_desc "net" "系统" "网络工具速查（nc/nmap/arp-scan/iftop/nethogs）"

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
