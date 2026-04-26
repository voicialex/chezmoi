#!/usr/bin/env bash

_help_desc "git" "开发" "Git 常用命令（含 worktree）"

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
    git rebase -i branch-name                把当前分支的提交移到目标分支最新位置之上
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

  local _alias_conf="$HOME/.gitconfig.d/alias.conf"
  echo "  [alias] 自定义别名（${_alias_conf}）"
  if [ -f "$_alias_conf" ]; then
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
      ' "$_alias_conf"
    )"
    if [ -n "$alias_lines" ]; then
      printf '%s\n' "$alias_lines"
    else
      echo "    （未发现可解析的 alias 条目）"
    fi
  else
    echo "    （未找到 ${_alias_conf}）"
  fi

  cat <<'EOF'

  [注意]
    同一个分支不能同时被多个 worktree 检出
    删除 worktree 前先确认目录里没有未提交改动
    优先用 git worktree remove，不要手动删 .git/worktrees
─────────────────────────────────────────────────────────────
EOF
}
