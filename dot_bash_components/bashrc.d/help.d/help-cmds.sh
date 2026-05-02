#!/usr/bin/env bash

_help_desc "cmds" "命令" "现代终端基础命令（rg/duf/btop/进程管理）"

help-cmds() {
  cat <<'EOF'
── 现代终端基础命令 ──────────────────────────────────────────

  [grep → rg]     速度碾压，自动忽略 .gitignore
    rg "pattern"                 递归搜索
    rg -i "pattern"              忽略大小写
    rg -l "pattern"              只显示匹配的文件名
    rg -t py "pattern"           只搜 Python 文件
    rg -C 2 "pattern"            显示匹配行前后各 2 行

  [df → duf]      磁盘用量可视化
    duf                          显示所有磁盘分区
    duf /home                    只显示指定路径所在分区

  [top → btop]    最漂亮的系统监控
    btop                         启动监控面板
    btop 内按 q                  退出

  [ps]            查看进程详情
    ps aux                       查看所有进程（BSD 风格，有 CPU%/MEM%）
    ps -ef                       查看所有进程（SystemV 风格，有 PPID 父进程）
    ps aux | grep nginx          找 nginx 相关进程
    ps -p 1234 -o pid,%cpu,%mem,nlwp,ni,cmd
                                 查看指定进程的 CPU、内存、线程数、优先级、命令
    -o 列名说明:
      pid      进程 ID
      %cpu     CPU 占用百分比
      %mem     内存占用百分比
      nlwp     线程数量
      ni       优先级（nice 值，越低越优先，默认 0，范围 -20~19）
      cmd      完整命令

  [pgrep]         按名字查找进程 PID
    pgrep nginx                  返回所有 nginx 进程的 PID
    pgrep -l nginx               显示 PID + 进程名
    pgrep -a nginx               显示 PID + 完整命令行
    pgrep -u seb nginx           只找用户 seb 的 nginx 进程

  [killall]       按名字杀进程
    killall nginx                杀掉所有 nginx 进程
    killall -9 nginx             强制杀（SIGKILL）
    killall -l                   列出所有可用信号名
    killall -SIGHUP nginx        发送 SIGHUP 信号（常用于重载配置）

  [安装]
    sudo apt install ripgrep duf btop
─────────────────────────────────────────────────────────────
EOF
}
