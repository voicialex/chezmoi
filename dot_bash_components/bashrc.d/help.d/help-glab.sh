#!/usr/bin/env bash

_help_desc "glab" "开发" "GitLab CLI 下载与常用命令"

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
