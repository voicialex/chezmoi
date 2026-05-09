#!/usr/bin/env bash

_help_desc "docker" "开发" "Docker 下载与常用命令"

help-docker() {
  cat <<'EOF'
── Docker ─────────────────────────────────────────────────
  [安装]
    # 官方脚本（最简）
    curl -fsSL https://get.docker.com | sudo sh
    # 把自己加入 docker 组（免 sudo）
    sudo usermod -aG docker $USER
    # 重新登录生效，或临时生效：
    newgrp docker

  [验证]
    docker --version
    docker run hello-world

  [镜像管理]
    docker pull <image>              # 拉取镜像
    docker images                    # 列出本地镜像
    docker rmi <image>               # 删除镜像

  [容器生命周期]
    docker run <image>               # 创建并运行容器
    docker run -d <image>            # 后台运行
    docker run -it <image> bash      # 交互式进入
    docker run --rm <image>          # 运行完自动删除
    docker run -v /host:/container   # 挂载目录
    docker run -p 8080:80 <image>    # 端口映射
    docker ps                        # 查看运行中的容器
    docker ps -a                     # 查看所有容器（含已停止）
    docker stop <container>          # 停止
    docker start <container>         # 启动已停止的容器
    docker rm <container>            # 删除容器

  [进入运行中的容器]
    docker exec -it <container> bash

  [清理]
    docker system df                 # 查看磁盘占用
    docker system prune              # 清理无用镜像/容器/网络
    docker system prune -a           # 清理全部未使用镜像（慎用）

  [Docker Compose]
    docker compose up -d             # 启动（后台）
    docker compose down              # 停止并删除
    docker compose logs -f           # 查看日志
    docker compose ps                # 查看状态

  [常见问题]
    # 权限错误：Got permission denied
      sudo usermod -aG docker $USER && newgrp docker

    # WSL 中 Docker 无法启动
      # 方案1: 使用 Docker Desktop for Windows（推荐）
      # 方案2: sudo service docker start
─────────────────────────────────────────────────────────────
EOF
}
